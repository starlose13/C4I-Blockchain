// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {Script} from "forge-std/Script.sol";
import {NodeManager} from "../src/Protocol/NodeManager.sol";

contract NodeManagerScript is Script {
    NodeManager public nodeManager;

    function run() external returns (NodeManager) {
        vm.startBroadcast();
        // Assuming you have valid addresses
        address[] memory initialAddresses = new address[](2);

        initialAddresses[0] = makeAddr("ALICE Commander"); // Replace with actual address 1
        initialAddresses[1] = makeAddr("BOB Commander"); // Replace with actual address 2

        string[] memory initialPositions = new string[](2);
        initialPositions[0] = "Position 1";
        initialPositions[1] = "Position 2";

        nodeManager = new NodeManager(initialAddresses, initialPositions);
        vm.stopBroadcast();

        return nodeManager;
    }
}
