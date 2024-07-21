// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Errors} from "../Helper/Errors.sol";
import {DataTypes} from "../Helper/DataTypes.sol";
import {INodeManager} from "../../../interfaces/INodeManager.sol";
import {IConsensusMechanism} from "../../../interfaces/IConsensusMechanism.sol";
import {Utils} from "./../Helper/Utils.sol";
import {OwnableUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import {AccessControlUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/access/AccessControlUpgradeable.sol";
import {AddressUpgradeable} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/vendor/openzeppelin-contracts-upgradeable/v4.8.1/utils/AddressUpgradeable.sol";

/**
 * @title ConsensusMechanism
 * @author SunAir institue, University of Ferdowsi
 * @dev Manages the consensus process among nodes for various operations.
 */
contract ConsensusMechanism is
    Initializable,
    UUPSUpgradeable,
    OwnableUpgradeable,
    AccessControlUpgradeable
{
    /*//////////////////////////////////////////////////////////////
                           STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    INodeManager private nodeManager; // Address of NodeManager Smart Contract
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    address private POLICY_CUSTODIAN;
    uint64 private constant CONSENSUS_NOT_REACHED = 0;
    uint64 private s_consensusThreshold; // Threshold for reaching consensus
    uint128 private s_epochCounter;
    uint256 private consensusEpochTimeDuration = 1 minutes;
    uint256 private s_startTime; // Start time for each consensus epoch
    uint256 public s_lastTimeStamp; // Timestamp for Chainlink auto-execution
    uint256 private s_interval; // Chainlink interval
    bool public isEpochNotStarted = true;

    /*//////////////////////////////////////////////////////////////
                               MAPPINGS
    //////////////////////////////////////////////////////////////*/

    // Mapping to store target locations reported by nodes
    mapping(address => DataTypes.TargetLocation) private s_target;

    // Mapping to store consensus data for each epoch
    mapping(address => mapping(uint128 => DataTypes.EpochConsensusData))
        private s_epochResolution;

    // Mapping to store consensus result for each epoch
    mapping(uint256 => uint256) private s_resultInEachEpoch;

    /*//////////////////////////////////////////////////////////////
                             CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor() {
        _disableInitializers();
    }

    /**
     * @dev Initializes the contract with initial consensus threshold and node manager address.
     * @param _s_consensusThreshold Initial consensus threshold.
     * @param nodeManagerContractAddress Address of the NodeManager contract.
     * @param policyCustodian Address of the owner of NodeManager contract.
     */
    function initialize(
        uint8 _s_consensusThreshold,
        address nodeManagerContractAddress,
        address policyCustodian
    ) public initializer {
        __Ownable_init(policyCustodian);
        __UUPSUpgradeable_init();
        __AccessControl_init();
        POLICY_CUSTODIAN = policyCustodian;
        s_lastTimeStamp = block.timestamp;
        s_consensusThreshold = _s_consensusThreshold;
        nodeManager = INodeManager(nodeManagerContractAddress);
    }

    /*//////////////////////////////////////////////////////////////
                              MODIFIERS
    //////////////////////////////////////////////////////////////*/
    /**
     * @dev Modifier to restrict function access to the policy custodian.
     */

    modifier onlyPolicyCustodian() {
        if (msg.sender != POLICY_CUSTODIAN) {
            revert Errors.ConsensusMechanism__ONLY_POLICY_CUSTODIAN();
        }
        _;
    }

    /**
     * @dev Modifier to ensure the correct sender is calling the function.
     * @param agent The expected sender address.
     */
    modifier ensureCorrectSender(address agent) {
        if (msg.sender != agent) {
            revert Errors.ConsensusMechanism__YOU_ARE_NOT_CORRECT_SENDER();
        }
        _;
    }

    /**
     * @dev Modifier to prevent double voting by the same node.
     * @param agent The address of the node.
     */
    modifier preventDoubleVoting(address agent) {
        if (hasNodeParticipated(agent) == true) {
            revert Errors.ConsensusMechanism__NODE_ALREADY_VOTED();
        }
        _;
    }
    /**
     * @dev Modifier to restrict function access to registered nodes.
     * @param agent The address of the node.
     */

    modifier onlyRegisteredNodes(address agent) {
        if (nodeManager.isNodeRegistered(agent) == false) {
            revert Errors.ConsensusMechanism__NODE_NOT_REGISTERED();
        }
        _;
    }

    /*//////////////////////////////////////////////////////////////
                              FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                           PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    /**
     * @dev Reports a target location by a node agent.
        This function ensures that the caller is the agent, prevents double voting,
        and only allows registered nodes to report.
     * @param agent Address of the reporting node.
     * @param announceTarget Target zone being reported.
     */

    function reportTargetLocation(
        address agent,
        DataTypes.TargetZone announceTarget
    )
        public
        ensureCorrectSender(agent)
        preventDoubleVoting(agent)
        onlyRegisteredNodes(agent)
    {
        _updateEpochStatus();
        _persistData(agent, announceTarget);
        _chronicleEpoch(agent, announceTarget);
        emit DataTypes.TargetLocationReported(agent, announceTarget);
    }

    /*
     * @dev Simulates the reporting of target locations by multiple node agents.
     *      This function is designed for testing and simulation purposes, allowing
     *      bulk reporting of target locations in a single transaction. It ensures
     *      that each agent is associated with a corresponding target zone.
     *
     * @param agents An array of addresses representing the node agents that are reporting.
     *               Each address must correspond to a registered and valid node agent
     *               as per the contract's requirements.
     * @param announceTargets An array of TargetZone structs representing the target zones
     *                        being reported. Each entry corresponds to the respective agent
     *                        at the same index in the `agents` array.
     *
     * @notice The lengths of the `agents` and `announceTargets` arrays must be equal.
     * @notice Only addresses in the `validAddresses` list can call this function.
     */
    function TargetLocationSimulation(
        address[] memory agents,
        DataTypes.TargetZone[] memory announceTargets
    ) public {
        if (agents.length != announceTargets.length) {
            revert Errors.ARRAYS_LENGTH_IS_NOT_EQUAL();
        }
        for (uint i = 0; i < agents.length; i++) {
            _reportTargetLocationBypassSender(agents[i], announceTargets[i]);
            emit DataTypes.TargetLocationSimulated(
                agents[i],
                announceTargets[i]
            );
        }
        isEpochNotStarted = false;
    }

    /**
     * @dev Checks if a node has already participated in the current epoch.
     * @param agent The address of the node.
     * @return Boolean indicating if the node has participated.
     */
    function hasNodeParticipated(address agent) public view returns (bool) {
        return (s_target[agent].reportedBy != address(0));
    }

    /*//////////////////////////////////////////////////////////////
                          INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function _authorizeUpgrade(
        address newImplementation
    ) internal view override onlyRole(UPGRADER_ROLE) {
        if (msg.sender != POLICY_CUSTODIAN) {
            revert Errors.NodeManager__CALLER_IS_NOT_AUTHORIZED();
        }
        require(
            AddressUpgradeable.isContract(newImplementation),
            "New implementation is not a contract"
        );
    }

    /*
     * @dev Internal function to report target location for a specific agent.
     *      This bypasses the ensureCorrectSender check but retains other checks.
     *      It is intended to be called by TargetLocationSimulation for simulation purposes.
     *
     * @param agent The address of the agent reporting the target location.
     * @param announceTarget The target zone being reported by the agent.
     */

    function _reportTargetLocationBypassSender(
        address agent,
        DataTypes.TargetZone announceTarget
    ) internal preventDoubleVoting(agent) onlyRegisteredNodes(agent) {
        _updateEpochStatus();
        _persistData(agent, announceTarget);
        _chronicleEpoch(agent, announceTarget);
    }

    function _updateEpochStatus() internal {
        if (isEpochNotStarted) {
            s_startTime = block.timestamp;
            isEpochNotStarted = false;
            emit DataTypes.EpochStatusUpdated(s_startTime, isEpochNotStarted);
        }
    }

    /**
     * @dev Persists the reported target location data.
     * @param agent Address of the reporting node.
     * @param announceTarget Target zone being reported.
     */
    function _persistData(
        address agent,
        DataTypes.TargetZone announceTarget
    ) internal {
        s_target[agent].zone = DataTypes.TargetZone(announceTarget); // Location of target (lat & long) that reported
        s_target[agent].reportedBy = agent; // Address of the node that reported this location
        s_target[agent].timestamp = block.timestamp; // Time when the location was reported
        s_target[agent].isActive = true; //to mark if the proposal is still active
    }

    /**
     * @dev Chronicles the epoch data with the reported target zone.
     * @param agent Address of the reporting node.
     * @param _reportedZone Target zone being reported.
     */

    function _chronicleEpoch(
        address agent,
        DataTypes.TargetZone _reportedZone
    ) internal {
        s_epochResolution[agent][s_epochCounter] = DataTypes
            .EpochConsensusData({
                zone: DataTypes.TargetZone(_reportedZone),
                timestamp: block.timestamp
            });
    }

    /*
     * @dev Deletes all data in the s_epochResolution mapping for a specific uint128 key.
     * @param epoch The uint128 key for which all data should be deleted.
     * @notice this function just delete epoch data when consensus not reached in the specific epoch
     */
    function deleteEpochData(uint128 epoch) internal {
        for (uint i = 0; i < nodeManager.numberOfPresentNodes(); i++) {
            address key = nodeManager.retrieveAddressByIndex(i);
            delete s_epochResolution[key][epoch];
        }
    }

    /**
     * @dev Computes the outcome of the consensus process.
     * @return The index of the target zone with the maximum votes.
     */

    function computeConsensusOutcome() internal view virtual returns (uint256) {
        uint256[] memory zoneCounts = new uint256[](
            uint256(type(DataTypes.TargetZone).max) + 1
        );

        uint256 numberOfNodes = nodeManager.numberOfPresentNodes();
        for (uint256 i = 0; i < numberOfNodes; i++) {
            // locationCounts[participations[i]]++;
            address nodeAddress = nodeManager.retrieveAddressByIndex(i);
            DataTypes.TargetZone zone = s_target[nodeAddress].zone;
            if (zone == DataTypes.TargetZone.EnemyBunkers) {
                zoneCounts[uint256(DataTypes.TargetZone.EnemyBunkers)] += 1; // index of DataTypes.TargetZone of 1 (lat) it can be changed if the inputs of targetZone have been changed
            } else if (zone == DataTypes.TargetZone.ArtilleryEmplacements) {
                zoneCounts[
                    uint256(DataTypes.TargetZone.ArtilleryEmplacements)
                ] += 1; //index of DataTypes.TargetZone of 2 (long) it can be changed if the inputs of targetZone have been changed
            } else if (zone == DataTypes.TargetZone.CommunicationTowers) {
                zoneCounts[
                    uint256(DataTypes.TargetZone.CommunicationTowers)
                ] += 1; //index of DataTypes.TargetZone of 2 (long) it can be changed if the inputs of targetZone have been changed
            } else if (zone == DataTypes.TargetZone.ObservationPosts) {
                zoneCounts[uint256(DataTypes.TargetZone.ObservationPosts)] += 1; //index of DataTypes.TargetZone of 2 (long) it can be changed if the inputs of targetZone have been changed
            }
        }
        // Find the zone with the maximum unique count using an external utility function
        (uint256 maxZoneIndex, uint256 maxCount) = Utils
            .findMaxUniqueValueWithCount(zoneCounts);
        // Check if the count meets the consensus threshold
        return
            (maxCount >= s_consensusThreshold)
                ? maxZoneIndex
                : CONSENSUS_NOT_REACHED;
    }

    /**
     * @dev Deletes the target location data for a specific node.
     * @param index Index of the node in the node manager.
     */
    function deleteTargetLocation(uint256 index) internal virtual {
        address targetAddress = nodeManager.retrieveAddressByIndex(index);
        // Nullify the TargetLocation struct for the current address
        delete s_target[targetAddress];
    }

    /**
     * @dev Resets the state to defaults for the next epoch.
     */
    function resetToDefaults() internal {
        s_startTime = block.timestamp;
        resetAllTargetLocations();
    }

    /**
     * @dev Resets all target locations to defaults.
     */
    function resetAllTargetLocations() internal {
        // Iterate over all addresses in the mapping
        for (uint256 i = 0; i < nodeManager.numberOfPresentNodes(); i++) {
            deleteTargetLocation(i);
        }
    }

    /*//////////////////////////////////////////////////////////////
                          EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    /**
     * @dev Executes the consensus automation and checks if consensus is reached.
     * @return isReached Boolean indicating if consensus was reached.
     * @return target Target zone with the consensus.
     */
    function consensusAutomationExecution()
        external
        returns (bool isReached, uint256 target)
    {
        if (s_startTime + consensusEpochTimeDuration >= block.timestamp) {
            revert Errors.ConsensusMechanism__TIME_IS_NOT_REACHED();
        }
        if (isEpochNotStarted) {
            revert Errors.ConsensusMechanism__VOTING_IS_INPROGRESS();
        }
        uint256 consensusResult = computeConsensusOutcome();
        if (consensusResult != 0) {
            isReached = true;
            s_resultInEachEpoch[s_epochCounter] = consensusResult;
            s_epochCounter += 1;
        } else if (consensusResult == 0) {
            deleteEpochData(s_epochCounter);
        }
        resetToDefaults();
        isEpochNotStarted = true;
        emit DataTypes.ConsensusExecuted(isReached, target, s_epochCounter);
        return (isReached, consensusResult);
    }

    /**
     * @dev Checks if upkeep is needed for the automation process.
     * @return upkeepNeeded Boolean indicating if upkeep is needed.
     */
    function checkUpkeep(
        bytes calldata /* checkData */
    ) external view returns (bool upkeepNeeded /* performData */) {
        upkeepNeeded = (block.timestamp - s_lastTimeStamp) > s_interval;
        // We don't use the checkData in this example. The checkData is defined when the Upkeep was registered.
    }

    /**
     * @dev Fetches the current consensus threshold.
     * @return The current consensus threshold.
     */
    function fetchConsensusThreshold() external view returns (uint64) {
        return s_consensusThreshold;
    }

    /**
     * @dev Modifies the duration of each consensus epoch.
     * @param newEpochTimeDurationInMinute New epoch duration in minutes.
     */

    function modifyEpochDuration(
        uint256 newEpochTimeDurationInMinute
    ) external onlyPolicyCustodian {
        consensusEpochTimeDuration = (newEpochTimeDurationInMinute * 1 minutes);
    }

    /**
     * @dev Modifies the consensus threshold.
     * @param newThreshold New consensus threshold.
     */
    function modifyConsensusThreshold(
        uint64 newThreshold
    ) external onlyPolicyCustodian {
        uint256 numberOfNodes = nodeManager.numberOfPresentNodes();
        if (newThreshold > numberOfNodes) {
            revert Errors.ConsensusMechanism__THRESHOLD_EXCEEDS_NODES();
        }
        uint64 previousThreshold = s_consensusThreshold;
        s_consensusThreshold = newThreshold;
        emit DataTypes.ConsensusThresholdModified(
            previousThreshold,
            newThreshold
        ); // Emit event
    }

    /**
     * @dev Performs upkeep for the automation process.
     * param performData Data for performing upkeep (not used in this example).
     */
    function performUpkeep(bytes calldata /* performData */) external {
        if ((block.timestamp - s_lastTimeStamp) > s_interval) {
            s_lastTimeStamp = block.timestamp;
        }
        // We don't use the performData in this example. The performData is generated by the Automation Node's call to your checkUpkeep function
    }

    /*//////////////////////////////////////////////////////////////
                               GETTERS
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Fetches consensus zones for a specific epoch.
     * @param epochCounter The epoch counter to fetch data for.
     * @return nodes Array of node addresses.
     * @return zones Array of target zones reported by nodes.
     */
    function fetchEpochConsensusZones(
        uint128 epochCounter
    )
        public
        view
        returns (address[] memory nodes, DataTypes.TargetZone[] memory zones)
    {
        // Retrieve total number of nodes
        uint256 totalNodes = nodeManager.numberOfPresentNodes();

        // Initialize arrays to store node addresses and their corresponding target zones
        nodes = new address[](totalNodes);
        zones = new DataTypes.TargetZone[](totalNodes);

        // Iterate over all nodes
        for (uint256 i = 0; i < totalNodes; i++) {
            // Get node address
            address nodeAddress = nodeManager.retrieveAddressByIndex(i);

            // Get target zone for the specified epoch and node
            DataTypes.TargetZone zone = s_epochResolution[nodeAddress][
                epochCounter
            ].zone;

            // Store node address and corresponding target zone
            nodes[i] = nodeAddress;
            zones[i] = zone;
        }

        // Return node addresses and their corresponding target zones
        return (nodes, zones);
    }

    /**
     * @dev Fetches the policy custodian address.
     * @return The policy custodian address.
     */
    function fetchPolicyCustodian() external view returns (address) {
        return POLICY_CUSTODIAN;
    }

    /**
     * @dev Fetches the number of epochs.
     * @return The number of epochs.
     */
    function fetchNumberOfEpoch() external view returns (uint256) {
        return s_epochCounter;
    }

    /**
     * @dev Fetches the duration of the consensus epoch.
     * @return The consensus epoch duration.
     */
    function fetchConsensusEpochTimeDuration() external view returns (uint256) {
        return consensusEpochTimeDuration;
    }

    /**
     * @dev Fetches the target location reported by a specific agent.
     * @param agent The address of the agent.
     * @return The target location data.
     */
    function fetchTargetLocation(
        address agent
    ) external view returns (DataTypes.TargetLocation memory) {
        return s_target[agent];
    }

    /*
     * @dev Fetches the result of a specific epoch.
     *
     * @param epoch The epoch number for which the result is to be fetched.
     * @return uint256 The result of the specified epoch.
     */

    function fetchResultOfEachEpoch(
        uint256 epoch
    ) public view returns (uint256) {
        return s_resultInEachEpoch[epoch];
    }

    function fetchStartTime() external view returns (uint256) {
        return s_startTime;
    }
}
