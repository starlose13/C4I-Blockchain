// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {Script} from "forge-std/Script.sol";
import {NodeManager} from "../src/Protocol/NodeManager.sol";

contract NodeManagerScript is Script {
    NodeManager public nodeManager;

    function run() external returns (NodeManager) {
        vm.startBroadcast();
        nodeManager = new NodeManager();
        vm.stopBroadcast();
        return nodeManager;
    }
}
