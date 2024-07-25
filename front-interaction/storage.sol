// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

contract StorageContract {

    uint256 number;

    function setValue(uint256 _number) public {
        number = _number;
    }
    function getNumber() external view returns(uint256){
        return number;
        }
}