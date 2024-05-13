// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

/**
 * @title Errors library
 * @author SunAir
 * @notice Defines the error messages emitted by the different contracts of the BLOCKCHAINENVIROCOMM protocol
 */
library Errors {
    error CALLER_NOT_IS_VALID_NODE(); // 'The caller of the function is not a commander that can participate in the mission'
}
