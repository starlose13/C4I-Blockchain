// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

/**
 * @title Utils library
 * @author SunAir
 * @notice math library
 */
library Utils {
    function max(uint256[] memory numbers) external pure returns (uint256) {
        require(numbers.length > 0); // throw an exception if the condition is not met
        uint256 maxNumber; // default 0, the lowest value of `uint256`

        for (uint256 i = 0; i < numbers.length; i++) {
            if (numbers[i] > maxNumber) {
                maxNumber = i;
            }
        }

        return maxNumber;
    }

    function maxUnique(uint256[] memory numbers) public pure returns (uint256) {
        require(numbers.length > 0, "Array must not be empty");

        uint256 maxNumber;
        bool hasDuplicates = false;

        for (uint256 i = 0; i < numbers.length; i++) {
            if (numbers[i] > maxNumber) {
                maxNumber = i;
                hasDuplicates = false;
            } else if (numbers[i] == maxNumber) {
                hasDuplicates = true;
            }
        }

        return (hasDuplicates ? 0 : maxNumber);
    }
}
