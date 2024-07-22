// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;
import {Script} from "forge-std/Script.sol";
import {NodeManager} from "../contracts/ethereum/Protocol/NodeManager.sol";
import {DataTypes} from "../contracts/ethereum/Helper/DataTypes.sol";
import {ERC1967Proxy} from "lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract NodeManagerScript is Script {
    function run() external returns (address) {
        address proxy = deployNodeManager();
        return proxy;
    }

    function deployNodeManager() public returns (address) {
        address[] memory initialNodeAddresses = new address[](2);
        initialNodeAddresses[0] = makeAddr("ALICE Commander"); // Replace with actual address 1
        initialNodeAddresses[1] = makeAddr("BOB Commander"); // Replace with actual address 2
        string[] memory nodesIPFSData = new string[](2);
        nodesIPFSData[0] = "Position 1";
        nodesIPFSData[1] = "Position 2";
        DataTypes.NodeRegion[] memory nodesRegions = new DataTypes.NodeRegion[](
            2
        );
        nodesRegions[0] = DataTypes.NodeRegion.North;
        nodesRegions[1] = DataTypes.NodeRegion.North;
        vm.startBroadcast();
        NodeManager nodeManager = new NodeManager();
        ERC1967Proxy proxy = new ERC1967Proxy(address(nodeManager), "");
        NodeManager(address(proxy)).initialize(
            initialNodeAddresses,
            nodesRegions,
            nodesIPFSData
        );
        vm.stopBroadcast();
        return address(proxy);
    }
}
