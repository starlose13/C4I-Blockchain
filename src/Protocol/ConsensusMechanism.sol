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
    uint64 private s_consensusThreshold; // threshold for having a consensus
    uint64 private constant CONSENSUS_NOT_REACHED = 0;
    uint256 private constant CONSENSUS_EPOCH_TIME = 10 minutes;
    uint256 private s_startTime;
    uint256 private s_lastTimeStamp; // chainlink auto-execution time
    uint256 private s_interval; // chainlink interval

    mapping(address => DataTypes.TargetLocation) public s_target;

    constructor(
        uint8 _s_consensusThreshold,
        address _nodeManagerContractAddress
    ) {
        POLICY_CUSTODIAN = msg.sender;
        s_lastTimeStamp = block.timestamp;
        s_consensusThreshold = _s_consensusThreshold;
        s_startTime = block.timestamp;
        nodeManager = INodeManager(_nodeManagerContractAddress);
    }

    modifier onlyPolicyCustodian() {
        if (msg.sender != POLICY_CUSTODIAN) {
            revert Errors.ConsensusMechanism__ONLY_POLICY_CUSTODIAN();
        }
        _;
    }

    function reportTargetLocation(
        address _nodeAddress,
        DataTypes.TargetZone _announceTarget
    ) external {
        if (msg.sender != _nodeAddress) {
            revert Errors.ConsensusMechanism__YOU_ARE_NOT_CORRECT_SENDER();
        }
        if (hasNodeParticipated(_nodeAddress) == true) {
            revert Errors.ConsensusMechanism__NODE_ALREADY_VOTED();
        }
        if (nodeManager.isNodeRegistered(_nodeAddress) == false) {
            revert Errors.ConsensusMechanism__NODE_NOT_REGISTERED();
        }

        s_target[msg.sender].zone = DataTypes.TargetZone(_announceTarget); // Location of target (lat & long) that reported
        s_target[msg.sender].reportedBy = msg.sender; // Address of the node that reported this location
        s_target[msg.sender].timestamp = block.timestamp; // Time when the location was reported
        s_target[msg.sender].isActive = true; //to mark if the proposal is still active
        emit DataTypes.TargetLocationReported(msg.sender, _announceTarget);
    }

    function consensusAutomationExecution() external returns (bool isReached) {
        if (
            s_startTime + CONSENSUS_EPOCH_TIME >= block.timestamp &&
            checkConsensusReached() != 0
        ) {
            resetToDefaults();
            return isReached = true;
        } else {
            resetToDefaults();
            return isReached = false;
        }
    }

    function checkConsensusReached() internal view virtual returns (uint256) {
        uint256[] memory zoneCounts = new uint256[](
            uint256(type(DataTypes.TargetZone).max) + 1
        );
        // Loop through participations (replace with your data source)
        uint256 numberOfNodes = nodeManager.numberOfPresentNodes();
        for (uint256 i = 0; i < numberOfNodes; i++) {
            // locationCounts[participations[i]]++;
            address nodeAddress = nodeManager.retrieveAddressByIndex(i);
            DataTypes.TargetZone zone = s_target[nodeAddress].zone;
            if (zone == DataTypes.TargetZone.lat) {
                zoneCounts[uint256(DataTypes.TargetZone.lat)] += 1; // index of DataTypes.TargetZone of 1 (lat) it can be changed if the inputs of targetZone have been changed
            } else if (zone == DataTypes.TargetZone.long) {
                zoneCounts[uint256(DataTypes.TargetZone.long)] += 1; //index of DataTypes.TargetZone of 2 (long) it can be changed if the inputs of targetZone have been changed
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
        uint64 _newValue
    ) external onlyPolicyCustodian {
        s_consensusThreshold = _newValue;
    }

    function hasNodeParticipated(
        address _nodeAddress
    ) public view returns (bool) {
        return (s_target[_nodeAddress].reportedBy != address(0));
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
}
