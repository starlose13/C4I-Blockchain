//SPDX-Licence-Identifier : MIT
pragma solidity 0.8.24;
import {StorageScript} from "../script/StorageScript.s.sol";
import {Test} from "forge-std/Test.sol";
import {StorageContract} from "../front-interaction/storage.sol";
contract testStorageContract is Test{
StorageContract public storageContract;
    function setUp() external {
        StorageScript deployer = new StorageScript();
        storageContract = deployer.run();
    }
    function testSetValue() external {
        uint256 expectedValue = 2;
        storageContract.setValue(expectedValue);
        uint256 actualValue = storageContract.getNumber();
        assertEq(actualValue,expectedValue);
        
    }

}