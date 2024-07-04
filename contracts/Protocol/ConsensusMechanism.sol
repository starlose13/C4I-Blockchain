// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Errors} from "../Helper/Errors.sol";
import {DataTypes} from "../Helper/DataTypes.sol";
import {INodeManager} from "../../interfaces/INodeManager.sol";
import {IConsensusMechanism} from "../../interfaces/IConsensusMechanism.sol";
import {Utils} from "./../Helper/Utils.sol";

/**
 * @title ConsensusMechanism
 * @author SunAir institue, University of Ferdowsi
 * @dev Manages the consensus process among nodes for various operations.
 */
contract ConsensusMechanism {
    INodeManager public nodeManager;
    address private immutable POLICY_CUSTODIAN;
    uint64 private constant CONSENSUS_NOT_REACHED = 0;
    uint64 private s_consensusThreshold; // Threshold for reaching consensus
    uint128 private s_epochCounter;
    uint256 private consensusEpochTimeDuration = 10 minutes;
    uint256 private s_startTime; // Start time for each consensus epoch
    uint256 public s_lastTimeStamp; // Timestamp for Chainlink auto-execution
    uint256 private s_interval; // Chainlink interval
    bool public isEpochStarted;

    // Mapping to store target locations reported by nodes
    mapping(address => DataTypes.TargetLocation) public s_target;

    // Mapping to store consensus data for each epoch
    mapping(address => mapping(uint128 => DataTypes.EpochConsensusData))
        public s_epochResolution;

    /**
     * @dev Initializes the contract with initial consensus threshold and node manager address.
     * @param _s_consensusThreshold Initial consensus threshold.
     * @param nodeManagerContractAddress Address of the NodeManager contract.
     */
    constructor(
        uint8 _s_consensusThreshold,
        address nodeManagerContractAddress
    ) {
        POLICY_CUSTODIAN = msg.sender;
        s_lastTimeStamp = block.timestamp;
        s_consensusThreshold = _s_consensusThreshold;
        s_startTime = block.timestamp;
        nodeManager = INodeManager(nodeManagerContractAddress);
    }

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

    /**
     * @dev Reports a target location by a node agent.
     * @param agent Address of the reporting node.
     * @param announceTarget Target zone being reported.
     */

    function reportTargetLocation(
        address agent,
        DataTypes.TargetZone announceTarget
    )
        external
        ensureCorrectSender(agent)
        preventDoubleVoting(agent)
        onlyRegisteredNodes(agent)
    {
        persistData(msg.sender, announceTarget);
        chronicleEpoch(msg.sender, announceTarget);
        isEpochStarted = true;
        emit DataTypes.TargetLocationReported(msg.sender, announceTarget);
    }

    /**
     * @dev Persists the reported target location data.
     * @param agent Address of the reporting node.
     * @param announceTarget Target zone being reported.
     */
    function persistData(
        address agent,
        DataTypes.TargetZone announceTarget
    ) private {
        s_target[msg.sender].zone = DataTypes.TargetZone(announceTarget); // Location of target (lat & long) that reported
        s_target[msg.sender].reportedBy = agent; // Address of the node that reported this location
        s_target[msg.sender].timestamp = block.timestamp; // Time when the location was reported
        s_target[msg.sender].isActive = true; //to mark if the proposal is still active
    }

    /**
     * @dev Chronicles the epoch data with the reported target zone.
     * @param agent Address of the reporting node.
     * @param _reportedZone Target zone being reported.
     */

    function chronicleEpoch(
        address agent,
        DataTypes.TargetZone _reportedZone
    ) private {
        s_epochResolution[agent][s_epochCounter] = DataTypes
            .EpochConsensusData({
                zone: DataTypes.TargetZone(_reportedZone),
                timestamp: block.timestamp
            });
    }

    /**
     * @dev Executes the consensus automation and checks if consensus is reached.
     * @return isReached Boolean indicating if consensus was reached.
     * @return target Target zone with the consensus.
     */
    function consensusAutomationExecution()
        external
        returns (bool isReached, uint256 target)
    {
        require(
            s_startTime + consensusEpochTimeDuration <= block.timestamp,
            "It is not time to run yet,Execution Failed!"
        );
        if (!isEpochStarted) {
            revert Errors.ConsensusMechanism__VOTING_IS_INPROGRESS();
        }
        uint256 consensusResult = computeConsensusOutcome();
        if (consensusResult != 0) {
            isReached = true;
            s_epochCounter += 1;
        }
        resetToDefaults();
        isEpochStarted = false;
        return (isReached, consensusResult);
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
        s_consensusThreshold = newThreshold;
    }

    /**
     * @dev Sets the consensus threshold.
     * @param newThreshold The new consensus threshold.
     */
    function setConsensusThreshold(
        uint8 newThreshold
    ) external onlyPolicyCustodian {
        s_consensusThreshold = newThreshold;
    }

    /**
     * @dev Checks if a node has already participated in the current epoch.
     * @param agent The address of the node.
     * @return Boolean indicating if the node has participated.
     */
    function hasNodeParticipated(address agent) public view returns (bool) {
        return (s_target[agent].reportedBy != address(0));
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
     * @dev Performs upkeep for the automation process.
     * param performData Data for performing upkeep (not used in this example).
     */
    function performUpkeep(bytes calldata /* performData */) external {
        if ((block.timestamp - s_lastTimeStamp) > s_interval) {
            s_lastTimeStamp = block.timestamp;
        }
        // We don't use the performData in this example. The performData is generated by the Automation Node's call to your checkUpkeep function
    }

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
}
