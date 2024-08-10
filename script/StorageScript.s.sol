//SPDX-Licence-Identifier : MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {StorageContract} from "../front-interaction/storage.sol";

contract StorageScript is Script{
StorageContract public storageContract;
    function run() external returns(StorageContract){
        vm.startBroadcast();
        storageContract = new StorageContract();
        vm.stopBroadcast();
        return (storageContract);

    }
}