// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Errors} from "../Helper/Errors.sol";
import {DataTypes} from "../Helper/DataTypes.sol";
import {INodeManager} from "../../interfaces/INodeManager.sol";
import {IConsensusMechanism} from "../../interfaces/IConsensusMechanism.sol";
import {Utils} from "./../Helper/Utils.sol";

contract ConsensusMechanism {
    INodeManager public nodeManager;
    address private immutable POLICY_CUSTODIAN;
    uint64 private constant CONSENSUS_NOT_REACHED = 0;
    uint64 private s_consensusThreshold; // threshold for having a consensus
    uint128 private s_epochCounter;
    uint256 private consensusEpochTimeDuration = 10 minutes;
    uint256 private s_startTime; // starting time for the each epoch of consensus process
    uint256 public s_lastTimeStamp; // chainlink auto-execution time
    uint256 private s_interval; // chainlink interval
    bool public isEpochStarted;

    mapping(address => DataTypes.TargetLocation) public s_target;
    mapping(address => mapping(uint128 => DataTypes.EpochConsensusData))
        public s_epochResolution;

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

    modifier onlyPolicyCustodian() {
        if (msg.sender != POLICY_CUSTODIAN) {
            revert Errors.ConsensusMechanism__ONLY_POLICY_CUSTODIAN();
        }
        _;
    }
    modifier ensureCorrectSender(address agent) {
        if (msg.sender != agent) {
            revert Errors.ConsensusMechanism__YOU_ARE_NOT_CORRECT_SENDER();
        }
        _;
    }
    modifier preventDoubleVoting(address agent) {
        if (hasNodeParticipated(agent) == true) {
            revert Errors.ConsensusMechanism__NODE_ALREADY_VOTED();
        }
        _;
    }
    modifier onlyRegisteredNodes(address agent) {
        if (nodeManager.isNodeRegistered(agent) == false) {
            revert Errors.ConsensusMechanism__NODE_NOT_REGISTERED();
        }
        _;
    }

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

    function persistData(
        address agent,
        DataTypes.TargetZone announceTarget
    ) private {
        s_target[msg.sender].zone = DataTypes.TargetZone(announceTarget); // Location of target (lat & long) that reported
        s_target[msg.sender].reportedBy = agent; // Address of the node that reported this location
        s_target[msg.sender].timestamp = block.timestamp; // Time when the location was reported
        s_target[msg.sender].isActive = true; //to mark if the proposal is still active
    }

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

    function consensusAutomationExecution()
        external
        returns (bool isReached, uint target)
    {
        require(
            s_startTime + consensusEpochTimeDuration <= block.timestamp,
            "It is not time to run yet,Execution Failed!"
        );
        if (!isEpochStarted) {
            revert Errors.ConsensusMechanism__VOTING_IS_INPROGRESS();
        }
        uint consensusResult = computeConsensusOutcome();
        if (consensusResult != 0) {
            isReached = true;
            s_epochCounter += 1;
        }
        resetToDefaults();
        isEpochStarted = false;
        return (isReached, consensusResult);
    }

    function modifyEpochDuration(
        uint newEpochTimeDurationInMinute
    ) external onlyPolicyCustodian {
        consensusEpochTimeDuration = (newEpochTimeDurationInMinute * 1 minutes);
    }

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
        (uint maxZoneIndex, uint maxCount) = Utils.findMaxUniqueValueWithCount(
            zoneCounts
        );
        // Check if the count meets the consensus threshold
        return
            (maxCount >= s_consensusThreshold)
                ? maxZoneIndex
                : CONSENSUS_NOT_REACHED;
    }

    function modifyConsensusThreshold(
        uint64 newThreshold
    ) external onlyPolicyCustodian {
        uint256 numberOfNodes = nodeManager.numberOfPresentNodes();
        if (newThreshold > numberOfNodes) {
            revert Errors.ConsensusMechanism__THRESHOLD_EXCEEDS_NODES();
        }
        s_consensusThreshold = newThreshold;
    }

    function hasNodeParticipated(address agent) public view returns (bool) {
        return (s_target[agent].reportedBy != address(0));
    }

    function deleteTargetLocation(uint index) internal virtual {
        address targetAddress = nodeManager.retrieveAddressByIndex(index);
        // Nullify the TargetLocation struct for the current address
        delete s_target[targetAddress];
    }

    function resetToDefaults() internal {
        s_startTime = block.timestamp;
        resetAllTargetLocations();
    }

    function resetAllTargetLocations() internal {
        // Iterate over all addresses in the mapping
        for (uint256 i = 0; i < nodeManager.numberOfPresentNodes(); i++) {
            deleteTargetLocation(i);
        }
    }

    function checkUpkeep(
        bytes calldata /* checkData */
    ) external view returns (bool upkeepNeeded /* performData */) {
        upkeepNeeded = (block.timestamp - s_lastTimeStamp) > s_interval;
        // We don't use the checkData in this example. The checkData is defined when the Upkeep was registered.
    }

    function fetchConsensusThreshold() external view returns (uint64) {
        return s_consensusThreshold;
    }

    function performUpkeep(bytes calldata /* performData */) external {
        if ((block.timestamp - s_lastTimeStamp) > s_interval) {
            s_lastTimeStamp = block.timestamp;
        }
        // We don't use the performData in this example. The performData is generated by the Automation Node's call to your checkUpkeep function
    }

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

    function fetchPolicyCustodian() external view returns (address) {
        return POLICY_CUSTODIAN;
    }

    function fetchNumberOfEpoch() external view returns (uint256) {
        return s_epochCounter;
    }

    //comment
    function fetchConsensusEpochTimeDuration() external view returns (uint256) {
        return consensusEpochTimeDuration;
    }

    function fetchTargetLocation(
        address agent
    ) external view returns (DataTypes.TargetLocation memory) {
        return s_target[agent];
    }
}
