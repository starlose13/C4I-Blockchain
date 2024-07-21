// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {NodeManager} from "../contracts/ethereum/Protocol/NodeManager.sol";
import {DataTypes} from "../contracts/ethereum/Helper/DataTypes.sol";
import {ConsensusMechanism} from "../contracts/ethereum/Protocol/ConsensusMechanism.sol";

contract ConsensusMechanismScript is Script {
    NodeManager public nodeManager;
    ConsensusMechanism public consensusMechanism;
    uint8 private THRESHOLD;

    function run() external returns (ConsensusMechanism) {
        vm.startBroadcast();
        // Assuming you have valid addresses
        address[] memory initialAddresses = new address[](3);
        initialAddresses[0] = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266; // Replace with actual address 1
        initialAddresses[1] = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8; // Replace with actual address 2
        initialAddresses[2] = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC; // Replace with actual address 3
        string[] memory IPFS = new string[](3);
        IPFS[0] = "Position 1";
        IPFS[1] = "Position 2";
        IPFS[2] = "Position 3";
        DataTypes.NodeRegion[] memory Type = new DataTypes.NodeRegion[](3);
        Type[0] = DataTypes.NodeRegion.North;
        Type[1] = DataTypes.NodeRegion.East;
        Type[2] = DataTypes.NodeRegion.West;
        nodeManager = new NodeManager();
        THRESHOLD = 2;
        consensusMechanism = new ConsensusMechanism();
        vm.stopBroadcast();
        return consensusMechanism;
    }
}
