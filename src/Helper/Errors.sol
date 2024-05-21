// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

/**
 * @title Errors library
 * @author SunAir
 * @notice Defines the error messages emitted by the different contracts of the BLOCKCHAINENVIROCOMM protocol
 */
library Errors {
    error NodeManager__CALLER_IS_NOT_VALID_NODE(); // 'The caller of the function is not a commander that can participate in the mission'
    error ConsensusMechanism__NODE_ALREADY_VOTED();
    error ConsensusMechanism__NODE_NOT_REGISTERED();
    error NodeManager__ARRAYS_LENGTH_IS_NOT_EQUAL();
    error NodeManager__NODE_ALREADY_EXIST();
}
