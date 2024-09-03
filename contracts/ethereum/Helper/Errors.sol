/*
 ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ 
▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ 
▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          
▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ 
▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀█░█▀▀ ▐░█▀▀▀▀█░█▀▀ ▐░▌       ▐░▌▐░█▀▀▀▀█░█▀▀  ▀▀▀▀▀▀▀▀▀█░▌
▐░▌          ▐░▌     ▐░▌  ▐░▌     ▐░▌  ▐░▌       ▐░▌▐░▌     ▐░▌            ▐░▌
▐░█▄▄▄▄▄▄▄▄▄ ▐░▌      ▐░▌ ▐░▌      ▐░▌ ▐░█▄▄▄▄▄▄▄█░▌▐░▌      ▐░▌  ▄▄▄▄▄▄▄▄▄█░▌
▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌
 ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀
 */

// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.24;

/**
 * @title Errors
 * @dev Defines custom error messages used in the contracts.
 */
library Errors {
    /*//////////////////////////////////////////////////////////////
                          NODEMANAGER ERRORS
    //////////////////////////////////////////////////////////////*/
    error NodeManager__CALLER_IS_NOT_AUTHORIZED(); // 'The caller of the function is not a commander that can manuplate the mission'
    error NodeManager__NODE_ALREADY_EXIST();
    error NodeManager__NODE_NOT_FOUND();

    /*//////////////////////////////////////////////////////////////
                           CONSENSUS ERRORS
    //////////////////////////////////////////////////////////////*/
    error ConsensusMechanism__NODE_ALREADY_VOTED();
    error ConsensusMechanism__NODE_NOT_REGISTERED();
    error ConsensusMechanism__YOU_ARE_NOT_CORRECT_SENDER();
    error ConsensusMechanism__ONLY_POLICY_CUSTODIAN();
    error ConsensusMechanism__THRESHOLD_EXCEEDS_NODES();
    error ConsensusMechanism__THERE_ARE_NO_ACTIVE_EPOCH();
    error ConsensusMechanism__ELECTION_IS_FINISHED();
    error ConsensusMechanism__UPKEEP_NOT_NEEDED();
    error ConsensusMechanism__VOTING_IS_INPROGRESS_AND_NOT_REACHED();

    /*//////////////////////////////////////////////////////////////
                      ACCOUNT ABSTRACTION ERRORS
    //////////////////////////////////////////////////////////////*/
    error AccountAbstraction__NOT_FROM_ENTRYPOINT();
    error AccountAbstraction__NOT_FROM_ENTRYPOINT_OR_OWNER();
    error AccountAbstractions__CALL_FAILED(bytes result);

    /*//////////////////////////////////////////////////////////////
                            GLOBAL & OTHER ERRORS
    //////////////////////////////////////////////////////////////*/
    error ARRAYS_LENGTH_IS_NOT_EQUAL();
    error HelperConfig__INVALID_CHAIN_ID();
    error NOT_ZERO_ADDRESS_ALLOWED();
}
