// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Errors} from "../Helper/Errors.sol";
import {DataTypes} from "../Helper/DataTypes.sol";

contract ConsensusMechanism {
    error ConsensusMechanism__NodeVoted();
    // Threshold for consensus
    uint256 public constant CONSENSUS_THRESHOLD = 3; // example threshold

    uint private s_lastTimeStamp;
    uint private immutable i_interval;
    uint private counter;

    mapping(address => DataTypes.TargetLocation) public s_target;

    constructor(uint _i_interval) {
        s_lastTimeStamp = block.timestamp;
        i_interval = _i_interval;
    }

    function reportTargetLocation(string memory _announceTarget) external {
        if (hasNodeParticipated() == true) {
            revert ConsensusMechanism__NodeVoted();
        }
        s_target[msg.sender].location = _announceTarget; // Location of target (lat & long) that reported
        s_target[msg.sender].reportedBy = msg.sender; // Address of the node that reported this location
        s_target[msg.sender].timestamp = block.timestamp; // Time when the location was reported
        s_target[msg.sender].reported[msg.sender] = true; // to track if a node has voted
        s_target[msg.sender].isActive = true; //to mark if the proposal is still active
    }

    function initiateConsensusAttack() external {}

    function checkConsensusReached() external {}

    function hasNodeParticipated() public view returns (bool) {
        return s_target[msg.sender].reported[msg.sender]; // i think if you delete this function nothing will happen
    }

    function checkUpkeep(
        bytes calldata /* checkData */
    ) external view returns (bool upkeepNeeded /* performData */) {
        upkeepNeeded = (block.timestamp - s_lastTimeStamp) > i_interval;
        // We don't use the checkData in this example. The checkData is defined when the Upkeep was registered.
    }

    function performUpkeep(bytes calldata /* performData */) external {
        if ((block.timestamp - s_lastTimeStamp) > i_interval) {
            s_lastTimeStamp = block.timestamp;
            counter = counter + 1;
        }
        // We don't use the performData in this example. The performData is generated by the Automation Node's call to your checkUpkeep function
    }
}
