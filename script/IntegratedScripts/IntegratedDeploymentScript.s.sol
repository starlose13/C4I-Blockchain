// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.24;
import {Script} from "forge-std/Script.sol";
import {ConsensusMechanism} from "../../contracts/ethereum/Protocol/ConsensusMechanism.sol";
import {NodeManager} from "../../contracts/ethereum/Protocol/NodeManager.sol";
import {DataTypes} from "../../contracts/ethereum/Helper/DataTypes.sol";
import {ERC1967Proxy} from "lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract IntegratedDeploymentScript is Script {
    uint8 private constant THRESHOLD = 3;

    function run()
        external
        returns (
            address consensusProxyContract,
            address nodeManagerProxyContract,
            address policyCustodian
        )
    {
        vm.startBroadcast();
        (
            consensusProxyContract,
            nodeManagerProxyContract,
            policyCustodian
        ) = deployConsensusMechanism();
        vm.stopBroadcast();
        return (
            consensusProxyContract,
            nodeManagerProxyContract,
            policyCustodian
        );
    }

    function deployConsensusMechanism()
        internal
        returns (
            address consensusProxyContract,
            address nodeManagerProxyContract,
            address policyCustodian
        )
    {
        nodeManagerProxyContract = deployNodeManager();
        policyCustodian = NodeManager(nodeManagerProxyContract).retrieveOwner();
        consensusProxyContract = deployConsensusMechanismContract(
            nodeManagerProxyContract,
            policyCustodian
        );
        return (
            consensusProxyContract,
            nodeManagerProxyContract,
            policyCustodian
        );
    }

    function deployNodeManager()
        internal
        returns (address nodeManagerProxyContract)
    {
        // Deploy NodeManager and set initial values
        address[] memory initialNodeAddresses = new address[](6);
        string[] memory nodesIPFSData = new string[](6);
        DataTypes.NodeRegion[] memory nodesRegions = new DataTypes.NodeRegion[](
            6
        );

        initialNodeAddresses[0] = makeAddr("Alice");
        initialNodeAddresses[1] = makeAddr("Bob");
        initialNodeAddresses[2] = makeAddr("Carol");
        initialNodeAddresses[3] = makeAddr("Dave");
        initialNodeAddresses[4] = makeAddr("Eve");
        initialNodeAddresses[5] = makeAddr("Mallory");

        nodesIPFSData[0] = "Position 0";
        nodesIPFSData[1] = "Position 1";
        nodesIPFSData[2] = "Position 2";
        nodesIPFSData[3] = "Position 3";
        nodesIPFSData[4] = "Position 4";
        nodesIPFSData[5] = "Position 5";

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

    function deployConsensusMechanismContract(
        address nodeManagerProxy,
        address policyCustodian
    ) internal returns (address consensusProxyContract) {
        ConsensusMechanism consensusMechanism = new ConsensusMechanism();
        ERC1967Proxy consensusProxy = new ERC1967Proxy(
            address(consensusMechanism),
            ""
        );
        ConsensusMechanism(address(consensusProxy)).initialize(
            THRESHOLD,
            nodeManagerProxy,
            policyCustodian
        );
        return address(consensusProxy);
    }

    function makeAddr(string memory name) internal override returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}
