// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

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
    error ConsensusMechanism__VOTING_IS_INPROGRESS();
    error ConsensusMechanism__TIME_IS_NOT_REACHED();
    error ConsensusMechanism__ELECTION_IS_FINISHED();

    /*//////////////////////////////////////////////////////////////
                      ACCOUNT ABSTRACTION ERRORS
    //////////////////////////////////////////////////////////////*/
    error AccountAbstraction__NOT_FROM_ENTRYPOINT();

    /*//////////////////////////////////////////////////////////////
                            GLOBAL ERRORS
    //////////////////////////////////////////////////////////////*/
    error ARRAYS_LENGTH_IS_NOT_EQUAL();
}
