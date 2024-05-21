// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

/**
 * @title Data Types and Structrues library
 * @author SunAir
 * @notice Defines the essential structs that worked with the different contracts of the BLOCKCHAINENVIROCOMM protocol
 */
library DataTypes {
    enum Region {
        North,
        South,
        East,
        West,
        Central
    }
    struct RegisteredNodes {
        address node;
        string currentPosition;
    }

    // Proposal structure to manage node proposals
    struct TargetLocation {
        Region location;
        address reportedBy; // ID of the node that reported this location
        uint256 timestamp; // Time when the location was reported
        mapping(address => bool) reported; // to track if a node has voted
        bool isActive; // to mark if the proposal is still active
    }
    event TargetLocationReported(
        address indexed node,
        DataTypes.Region announceTarget
    );
}
