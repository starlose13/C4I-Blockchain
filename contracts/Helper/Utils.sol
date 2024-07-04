// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

/**
 * @title Utils library
 * @author SunAir
 * @notice math library
 */
library Utils {
    function findMaxUniqueValueWithCount(uint256[] memory numbers) public pure returns (uint256, uint256) {
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

        if (hasDuplicates) {
            return (0, 0);
        } else {
            return (maxIndex, maxNumber);
        }
    }
}
