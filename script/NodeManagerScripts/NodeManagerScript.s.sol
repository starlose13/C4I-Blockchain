// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;
import {Script} from "forge-std/Script.sol";
import {NodeManager} from "../../contracts/ethereum/Protocol/NodeManager.sol";
import {DataTypes} from "../../contracts/ethereum/Helper/DataTypes.sol";
import {ERC1967Proxy} from "lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract NodeManagerScript is Script {
    address public proxy;

    function run() external returns (address nodeProxyContract) {
        proxy = deployNodeManager();
        return proxy;
    }

    function deployNodeManager() public returns (address nodeProxyContract) {
        address[] memory initialNodeAddresses = new address[](6);
        // we have 6 nodes in our test cases scenario , some of them are malicious, some are not
        initialNodeAddresses[0] = makeAddr("Alice"); // Often represents the trusty sender in communications.
        initialNodeAddresses[1] = makeAddr("Bob"); // Often represents the trusty sender in communications.
        initialNodeAddresses[2] = makeAddr("Carol "); //Sometimes used to represent additional parties in multiparty communication.
        initialNodeAddresses[3] = makeAddr("Dave"); //Sometimes used to represent additional parties in multiparty communication.
        initialNodeAddresses[4] = makeAddr("Eve"); // Represents an opponent or adversary.
        initialNodeAddresses[5] = makeAddr("Mallory"); //Mallory: Represents a malicious attacker who not only listens to the communication but may also alter it.
        string[] memory nodesIPFSData = new string[](6);
        nodesIPFSData[0] = "Position 0";
        nodesIPFSData[1] = "Position 1";
        nodesIPFSData[2] = "Position 2";
        nodesIPFSData[3] = "Position 3";
        nodesIPFSData[4] = "Position 4";
        nodesIPFSData[5] = "Position 5";
        DataTypes.NodeRegion[] memory nodesRegions = new DataTypes.NodeRegion[](
            6
        );
        nodesRegions[0] = DataTypes.NodeRegion.North;
        nodesRegions[1] = DataTypes.NodeRegion.North;
        nodesRegions[2] = DataTypes.NodeRegion.North;
        nodesRegions[3] = DataTypes.NodeRegion.East;
        nodesRegions[4] = DataTypes.NodeRegion.West;
        nodesRegions[5] = DataTypes.NodeRegion.Central;

        NodeManager nodeManager = new NodeManager();
        ERC1967Proxy nodeManagerProxy = new ERC1967Proxy(
            address(nodeManager),
            ""
        );
        NodeManager(address(nodeManagerProxy)).initialize(
            initialNodeAddresses,
            nodesRegions,
            nodesIPFSData
        );
        return address(nodeManagerProxy);
    }
}
