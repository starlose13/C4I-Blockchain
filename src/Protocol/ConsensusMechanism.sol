// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Errors} from "../Helper/Errors.sol";
import {DataTypes} from "../Helper/DataTypes.sol";
import {INodeManager} from "../../interfaces/INodeManager.sol";
import {IConsensusMechanism} from "../../interfaces/IConsensusMechanism.sol";
import {Utils} from "./../Helper/Utils.sol";

contract ConsensusMechanism {
    INodeManager public nodeManager;
    uint64 private immutable i_consensusThreshold; // threshold for having a consensus
    uint64 private constant CONSENSUS_NOT_REACHED = 0;
    uint128 private constant CONSENSUS_EPOCH_TIME = 10 minutes;
    uint256 private s_lastTimeStamp; // chainlink auto-execution time
    uint256 private i_interval; // chainlink interval

    mapping(address => DataTypes.TargetLocation) public s_target;

    constructor(
        uint8 _i_consensusThreshold,
        address _nodeManagerContractAddress
    ) {
        s_lastTimeStamp = block.timestamp;
        i_consensusThreshold = _i_consensusThreshold;
        nodeManager = INodeManager(_nodeManagerContractAddress);
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

    function initiateConsensusAttack() external {}

    function checkConsensusReached() external view returns (uint256) {
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
            (maxCount >= i_consensusThreshold)
                ? maxZoneIndex
                : CONSENSUS_NOT_REACHED;
    }

    function hasNodeParticipated(
        address _nodeAddress
    ) public view returns (bool) {
        return (s_target[_nodeAddress].reportedBy != address(0));
    }

    function resetEpoch() external {
        for (uint256 i = 0; i < nodeManager.numberOfPresentNodes(); i++) {
            address targetAddress = nodeManager.retrieveAddressByIndex(i);
            s_target[targetAddress] = DataTypes.TargetLocation({
                zone: DataTypes.TargetZone(0), // Assuming 0 is a valid default value for TargetZone
                reportedBy: address(0),
                timestamp: 0,
                isActive: false
            });
        }
    }

    function resetAllTargetLocations() public {
        // Iterate over all addresses in the mapping
        for (uint256 i = 0; i < nodeManager.numberOfPresentNodes(); i++) {
            address targetAddress = nodeManager.retrieveAddressByIndex(i);

            // Nullify the TargetLocation struct for the current address
            delete s_target[targetAddress];
        }
    }

    function checkUpkeep(
        bytes calldata /* checkData */
    ) external view returns (bool upkeepNeeded /* performData */) {
        upkeepNeeded = (block.timestamp - s_lastTimeStamp) > i_interval;
        // We don't use the checkData in this example. The checkData is defined when the Upkeep was registered.
    }

    function fetchConsensusThreshold() external view returns (uint64) {
        return i_consensusThreshold;
    }

    function performUpkeep(bytes calldata /* performData */) external {
        if ((block.timestamp - s_lastTimeStamp) > i_interval) {
            s_lastTimeStamp = block.timestamp;
        }
        // We don't use the performData in this example. The performData is generated by the Automation Node's call to your checkUpkeep function
    }
}
