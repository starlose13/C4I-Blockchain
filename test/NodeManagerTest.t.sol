// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;
import {Test, console} from "forge-std/Test.sol";
import {NodeManager} from "../contracts/ethereum/Protocol/NodeManager.sol";
import {DataTypes} from "../contracts/ethereum/Helper/DataTypes.sol";
import {Errors} from "../contracts/ethereum/Helper/Errors.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {Initializable} from "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import {IntegratedDeploymentScript} from "../script/IntegratedScripts/IntegratedDeploymentScript.s.sol";
import {ConsensusMechanismScript} from "../script/ConsensusMechanismScripts/ConsensusMechanismScript.s.sol";

contract NodeManagerTest is Test {
    address consensusProxyContract;
    address nodeManagerProxyContract;
    address policyCustodian;

    function setUp() external {
        IntegratedDeploymentScript scriptDeployer = new IntegratedDeploymentScript();

        (
            consensusProxyContract,
            nodeManagerProxyContract,
            policyCustodian
        ) = scriptDeployer.run();
    }

    function testNodeManagerInitialization() public {
        uint256 expectedValue = 6;
        assertEq(
            NodeManager(nodeManagerProxyContract).numberOfPresentNodes(),
            expectedValue,
            "Incorrect number of nodes registered"
        );
    }

    function testRegisterRandomNode() public {
        address newNode = address(0x9ABC);
        DataTypes.NodeRegion newRegion = DataTypes.NodeRegion.East;
        string memory newNodePosition = "QmNewNode";
        string memory latitude = "10 N";
        string memory longitude = "52.1 W";
        vm.prank(policyCustodian);
        NodeManager(nodeManagerProxyContract).registerNewNode(
            newNode,
            newRegion,
            newNodePosition,
            latitude,
            longitude
        );
        DataTypes.RegisteredNodes[] memory nodes = NodeManager(
            nodeManagerProxyContract
        ).retrieveAllRegisteredNodeData();
        assertEq(nodes.length, 7, "Node not added correctly");
        assertEq(nodes[6].nodeAddress, newNode, "New node address mismatch");
        assertEq(
            uint256(nodes[6].currentPosition),
            uint256(newRegion),
            "New node region mismatch"
        );
        assertEq(
            nodes[6].nodePosition,
            newNodePosition,
            "New node IPFS data mismatch"
        );
    }

    function testRegisterNewNodeNotAuthorized() public {
        address newNode = address(0x9ABC);
        DataTypes.NodeRegion newRegion = DataTypes.NodeRegion.East;
        string memory newNodePosition = "QmNewNode";
        string memory latitude = "102 N";
        string memory longitude = "50.1 W";

        vm.prank(newNode);
        vm.expectRevert(Errors.NodeManager__CALLER_IS_NOT_AUTHORIZED.selector);
        NodeManager(nodeManagerProxyContract).registerNewNode(
            newNode,
            newRegion,
            newNodePosition,
            latitude,
            longitude
        );
    }

    function testNodeAlreadyExists() public {
        DataTypes.RegisteredNodes[] memory nodes = NodeManager(
            nodeManagerProxyContract
        ).retrieveAllRegisteredNodeData();
        vm.prank(policyCustodian);
        vm.expectRevert(Errors.NodeManager__NODE_ALREADY_EXIST.selector);
        NodeManager(nodeManagerProxyContract).registerNewNode(
            nodes[0].nodeAddress,
            nodes[0].currentPosition,
            nodes[0].nodePosition,
            nodes[0].latitude,
            nodes[0].longitude
        );
    }

    function testUpdateNodeExpeditionary() public {
        DataTypes.RegisteredNodes[] memory nodeResults = NodeManager(
            nodeManagerProxyContract
        ).retrieveAllRegisteredNodeData();
        DataTypes.NodeRegion newRegion = DataTypes.NodeRegion.Central;
        vm.prank(policyCustodian);
        NodeManager(nodeManagerProxyContract).updateExpeditionaryForces(
            newRegion,
            nodeResults[0].nodeAddress
        );
        DataTypes.RegisteredNodes[] memory nodeResultsAfterChange = NodeManager(
            nodeManagerProxyContract
        ).retrieveAllRegisteredNodeData();
        assertEq(
            uint256(nodeResultsAfterChange[0].currentPosition),
            uint256(newRegion),
            "Node region update failed"
        );
    }

    function testUpdateExpeditionaryForcesNotAuthorized() public {
        DataTypes.RegisteredNodes[] memory nodeResults = NodeManager(
            nodeManagerProxyContract
        ).retrieveAllRegisteredNodeData();
        DataTypes.NodeRegion newRegion = DataTypes.NodeRegion.Central;
        vm.prank(nodeResults[0].nodeAddress);
        vm.expectRevert(Errors.NodeManager__CALLER_IS_NOT_AUTHORIZED.selector);
        NodeManager(nodeManagerProxyContract).updateExpeditionaryForces(
            newRegion,
            nodeResults[0].nodeAddress
        );
    }

    function testNumberOfCurrentNodes() public {
        uint256 count = NodeManager(nodeManagerProxyContract)
            .numberOfPresentNodes();
        uint256 expectedValue = 6;
        assertEq(count, expectedValue, "Number of present nodes mismatch");
    }

    function testRetrieveAddressByIndexOutOfBounds() public {
        vm.expectRevert();
        NodeManager(nodeManagerProxyContract).retrieveAddressByIndex(10);
    }

    function testRetrieveNodeDataByAddressNotFound() public {
        vm.expectRevert(Errors.NodeManager__NODE_NOT_FOUND.selector);
        NodeManager(nodeManagerProxyContract).retrieveNodeDataByAddress(
            address(0x9999)
        );
    }

    function testupdateNodeData() public {
        DataTypes.RegisteredNodes[] memory nodeResults = NodeManager(
            nodeManagerProxyContract
        ).retrieveAllRegisteredNodeData();
        string memory newNodePosition = "QmUpdatedNode";
        string memory newLatitude = "QmUpdatedNode";
        string memory newLongitude = "QmUpdatedNode";
        vm.prank(policyCustodian);
        NodeManager(nodeManagerProxyContract).updateNodeData(
            nodeResults[0].nodeAddress,
            newNodePosition,
            newLatitude,
            newLongitude
        );
        DataTypes.RegisteredNodes memory nodeData = NodeManager(
            nodeManagerProxyContract
        ).retrieveNodeDataByAddress(nodeResults[0].nodeAddress);
        assertEq(
            nodeData.nodePosition,
            newNodePosition,
            "IPFS data update failed"
        );
    }

    function testOnlyContractAdmin() public {
        DataTypes.RegisteredNodes[] memory nodeResults = NodeManager(
            nodeManagerProxyContract
        ).retrieveAllRegisteredNodeData();
        DataTypes.NodeRegion newRegion = DataTypes.NodeRegion.Central;
        address newNode = address(0x9ABC);
        string memory newNodePosition = "QmNewNode";
        string memory newLatitude = "10.22 N";
        string memory newLongitude = "53.22 N";
        // Test registerNewNode with non-admin
        vm.prank(nodeResults[0].nodeAddress);
        vm.expectRevert(Errors.NodeManager__CALLER_IS_NOT_AUTHORIZED.selector);
        NodeManager(nodeManagerProxyContract).registerNewNode(
            newNode,
            newRegion,
            newNodePosition,
            newLatitude,
            newLongitude
        );
        // Test updateExpeditionaryForces with non-admin
        vm.prank(nodeResults[0].nodeAddress);
        vm.expectRevert(Errors.NodeManager__CALLER_IS_NOT_AUTHORIZED.selector);
        NodeManager(nodeManagerProxyContract).updateExpeditionaryForces(
            newRegion,
            nodeResults[0].nodeAddress
        );
    }

    function testIsNodeRegistered() public {
        DataTypes.RegisteredNodes[] memory nodeResults = NodeManager(
            nodeManagerProxyContract
        ).retrieveAllRegisteredNodeData();
        bool isRegistered = NodeManager(nodeManagerProxyContract)
            .isNodeRegistered(nodeResults[0].nodeAddress);
        assertTrue(isRegistered, "Node should be registered");
        address nonExistentNode = address(0x5678);
        isRegistered = NodeManager(nodeManagerProxyContract).isNodeRegistered(
            nonExistentNode
        );
        assertFalse(isRegistered, "Node should not be registered");
    }

    function testInitializeCannotBeCalledTwice() public {
        address[] memory initialAddresses = new address[](0);
        DataTypes.NodeRegion[] memory Type = new DataTypes.NodeRegion[](0);
        string[] memory newNodePosition = new string[](0);
        string[] memory newLatitude = new string[](0);
        string[] memory newLongitude = new string[](0);
        NodeManager emptyNodeManager = new NodeManager();
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        emptyNodeManager.initialize(
            initialAddresses,
            Type,
            newNodePosition,
            newLatitude,
            newLongitude
        );
        DataTypes.RegisteredNodes[] memory nodes = emptyNodeManager
            .retrieveAllRegisteredNodeData();
        assertEq(nodes.length, 0, "There should be no nodes registered");
    }

    function testRetrieveOwner() public {}
}
