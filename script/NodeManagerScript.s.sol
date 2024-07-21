// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;
import {Script} from "forge-std/Script.sol";
import {NodeManager} from "../contracts/ethereum/Protocol/NodeManager.sol";
import {DataTypes} from "../contracts/ethereum/Helper/DataTypes.sol";

contract NodeManagerScript is Script {
    NodeManager public nodeManager;

    function run() external returns (NodeManager) {
        vm.startBroadcast();
        // Assuming you have valid addresses
        address[] memory initialAddresses = new address[](2);
        initialAddresses[0] = makeAddr("ALICE Commander"); // Replace with actual address 1
        initialAddresses[1] = makeAddr("BOB Commander"); // Replace with actual address 2
        string[] memory IPFS = new string[](2);
        IPFS[0] = "Position 1";
        IPFS[1] = "Position 2";
        DataTypes.NodeRegion[] memory Type = new DataTypes.NodeRegion[](2);
        Type[0] = DataTypes.NodeRegion.North;
        Type[1] = DataTypes.NodeRegion.North;
        nodeManager = new NodeManager();
        vm.stopBroadcast();
        return nodeManager;
    }
}
