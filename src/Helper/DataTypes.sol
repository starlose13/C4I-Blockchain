// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

/**
 * @title Data Types and Structrues library
 * @author SunAir
 * @notice Defines the essential structs that worked with the different contracts of the BLOCKCHAINENVIROCOMM protocol
 */
library DataTypes {
    /**
     * @dev Enum to represent different node regions.
     */
    enum NodeRegion {
        North,
        South,
        East,
        West,
        Central
    }
    /**
     * @dev Enum to represent different target zones.
     */

    enum TargetZone {
        None,
        EnemyBunkers,
        ArtilleryEmplacements,
        CommunicationTowers,
        ObservationPosts
    }
    /**
     * @dev Struct to store data of a registered node.
     */

    struct RegisteredNodes {
        address nodeAddress;
        NodeRegion currentPosition;
        string IPFSData;
    }

    /**
     * @dev Struct to store target location data.
     */
    struct TargetLocation {
        TargetZone zone;
        address reportedBy; // ID of the node that reported this location
        uint256 timestamp; // Time when the location was reported
        bool isActive; // to mark if the proposal is still active
    }
    /**
     * @dev Struct to store consensus data for an epoch.
     */

    struct EpochConsensusData {
        TargetZone zone;
        uint256 timestamp; // Time when the vote was committed
    }

    event TargetLocationReported(
        address indexed node,
        TargetZone announceTarget
    );
}
