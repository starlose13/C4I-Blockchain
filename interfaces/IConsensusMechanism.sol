// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;
import {DataTypes} from "../contracts/Helper/DataTypes.sol";

interface IConsensusMechanism {
    function reteriveTargetByAddress(
        address _addr
    ) external view returns (DataTypes.TargetLocation memory);

    // Function to initiate the consensus process
    function initiateConsensus() external;

    // Function to participate in the consensus process
    function participateInConsensus() external;

    // Function to check if consensus has been reached
    function isConsensusReached() external view returns (bool);

    // Function to finalize the consensus process
    function finalizeConsensus() external;

    // Event emitted when the consensus process is initiated
    event ConsensusInitiated();

    // Event emitted when a node participates in the consensus process
    event ConsensusParticipated(address indexed nodeAddress);

    // Event emitted when consensus is reached
    event ConsensusReached();

    // Event emitted when the consensus process is finalized
    event ConsensusFinalized();

    function reportTargetLocation(
        address _nodeAddress,
        DataTypes.TargetZone _announceTarget
    ) external;

    function consensusAutomationExecution() external returns (bool isReached);

    function checkConsensusReached() external view returns (uint256);

    function hasNodeParticipated(
        address _nodeAddress
    ) external view returns (bool);

    function deleteTargetLocation(uint index) external;

    function resetToDefaults() external;

    function resetAllTargetLocations() external;

    function checkUpkeep(
        bytes calldata /* checkData */
    ) external view returns (bool upkeepNeeded /* performData */);

    function fetchConsensusThreshold() external view returns (uint64);

    function performUpkeep(bytes calldata /* performData */) external;
}
