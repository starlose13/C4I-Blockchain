// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

/**
 * @title Data Types and Structrues library
 * @author SunAir
 * @notice Defines the essential structs that worked with the different contracts of the BLOCKCHAINENVIROCOMM protocol
 */
library DataTypes {
    struct RegisteredNodes {
        address node;
        string currentPosition;
    }
}
