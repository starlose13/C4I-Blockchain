// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.24;
import {Strings} from "lib/openzeppelin-contracts/contracts/utils/Strings.sol";

/**
 * @title Utils library
 * @author SunAir
 * @notice math library
 */
library Utils {
    /*//////////////////////////////////////////////////////////////
                              Functions
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Finds the maximum unique value in an array of unsigned integers.
     *      If the maximum value appears more than once, the function returns (0, 0).
     * @param numbers The array of unsigned integers (enum target posions) to search through.
     * @return A tuple where the first element is the index of the maximum unique value,
     *         and the second element is the maximum unique value itself. If the maximum
     *         value is not unique, both elements of the tuple will be 0.
     */
    function findMaxUniqueValueWithCount(
        uint256[] memory numbers
    ) external pure returns (uint256, uint256) {
        require(numbers.length > 0, "Array must not be empty");

        uint256 maxNumber;
        uint256 maxIndex;
        bool hasDuplicates = false;

        for (uint256 i = 0; i < numbers.length; i++) {
            if (numbers[i] > maxNumber) {
                maxNumber = numbers[i];
                maxIndex = i;
                hasDuplicates = false;
            } else if (numbers[i] == maxNumber) {
                hasDuplicates = true;
            }
        }
        // If duplicates of the maximum number were found, return (0, 0)
        if (hasDuplicates) {
            return (0, 0);
        } else {
            return (maxIndex, maxNumber);
        }
    }

    /**
     * @notice Converts an Ethereum address to its string representation in hexadecimal format
     * @param user The Ethereum address to be converted
     * @return A string representing the hexadecimal format of the provided address
     */
    function addressToString(
        address user
    ) external pure returns (string memory) {
        return Strings.toHexString(user);
    }

    /**
     * @notice Converts a uint256 timestamp to its string representation
     * @param timestamp The uint256 timestamp to be converted
     * @return A string representing the numeric value of the provided timestamp
     */

    function uint256ToString(
        uint timestamp
    ) external pure returns (string memory) {
        return Strings.toString(timestamp);
    }
}
