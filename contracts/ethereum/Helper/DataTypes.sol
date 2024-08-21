// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

/**
 * @title Data Types and Structrues library
 * @author SunAir
 * @notice Defines the essential structs that worked with the different contracts of the BLOCKCHAINENVIROCOMM protocol
 */
library DataTypes {
    /*//////////////////////////////////////////////////////////////
                                ENUMS
    //////////////////////////////////////////////////////////////*/
    /**
     * @dev Enum to represent different node regions.
     */
    enum NodeRegion {
        North, //0
        South, //1
        East,
        West,
        Central
    }
    /**
     * @dev Enum to represent different target zones.
     */

    enum TargetZone {
        None, // 0
        EnemyBunkers, // 1
        ArtilleryEmplacements, // 2
        CommunicationTowers, // 3
        ObservationPosts // 4
    }

    enum EpochVoteState {
        AwaitingStart, // 0
        Counting // 1
    }

    /*//////////////////////////////////////////////////////////////
                               STRUCTS
    //////////////////////////////////////////////////////////////*/
    /**
     * @dev Struct to store data of a registered node.
     */

    struct RegisteredNodes {
        address nodeAddress;
        NodeRegion currentPosition;
        string nodePosition;
        string latitude;
        string longitude;
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

    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/

    event TargetLocationReported(
        address indexed node,
        TargetZone announceTarget
    );
    event TargetLocationSimulated(
        address indexed agent,
        DataTypes.TargetZone announceTarget
    );
    event EpochStatusUpdated(uint256 startTime, EpochVoteState epochStatus);
    event ConsensusExecuted(
        bool isReached,
        uint256 target,
        uint256 epochCounter
    );
    event ConsensusThresholdModified(
        uint64 previousThreshold,
        uint64 newThreshold
    );
}
