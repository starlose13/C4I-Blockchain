// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

interface IConsensusMechanism {
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
}
