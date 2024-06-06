// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;
import {Test, console} from "forge-std/Test.sol";

import {NodeManager} from "../src/Protocol/NodeManager.sol";
import {DataTypes} from "../src/Helper/DataTypes.sol";
import {Errors} from "../src/Helper/Errors.sol";
import {NodeManagerScript} from "../script/NodeManagerScript.s.sol";

contract NodeManagerTest is Test {
    address private admin = address(0xABCD);
    address immutable FIRST_COMMANDER = makeAddr("ALICE Commander");
    address immutable SECOND_COMMANDER = makeAddr("BOB Commander");
    address immutable THIRD_COMMANDER = makeAddr("JHON Commander");
    DataTypes.NodeRegion private region1 = DataTypes.NodeRegion.North;
    DataTypes.NodeRegion private region2 = DataTypes.NodeRegion.South;
    string private ipfs1 = "QmNode1";
    string private ipfs2 = "QmNode2";
    NodeManager nodeManager;
    NodeManagerScript public nodeMangerScript;

    //third person who exercises authority chief officer; leader. the commissioned officer in command of a military unit

    function setUp() public {
        nodeMangerScript = new NodeManagerScript();
        nodeManager = nodeMangerScript.run();

        vm.deal(FIRST_COMMANDER, 100 ether);
        vm.deal(SECOND_COMMANDER, 100 ether);
        vm.deal(THIRD_COMMANDER, 100 ether);
        address[] memory nodes = new address[](2);
        nodes[0] = FIRST_COMMANDER;
        nodes[1] = SECOND_COMMANDER;

        DataTypes.NodeRegion[] memory regions = new DataTypes.NodeRegion[](2);
        regions[0] = region1;
        regions[1] = region2;

        string[] memory ipfsData = new string[](2);
        ipfsData[0] = ipfs1;
        ipfsData[1] = ipfs2;

        vm.prank(admin);
        nodeManager = new NodeManager(nodes, regions, ipfsData);
    }

    function testRegisterNode() public /*string memory _currentPositon*/ {
        vm.prank(FIRST_COMMANDER);
        // nodeManager.registerNode(FIRST_COMMANDER, _currentPositon);
    }

    function testInitialization() public {
        DataTypes.RegisteredNodes[] memory nodes = nodeManager
            .retrieveAllRegisteredNodeData();
        assertEq(nodes.length, 2);
        assertEq(nodes[0].nodeAddress, FIRST_COMMANDER);
        assertEq(uint(nodes[0].currentPosition), uint(region1));
        assertEq(nodes[0].IPFSData, ipfs1);
        assertEq(nodes[1].nodeAddress, SECOND_COMMANDER);
        assertEq(uint(nodes[1].currentPosition), uint(region2));
        assertEq(nodes[1].IPFSData, ipfs2);
    }

    function testRegisterNewNode() public {
        address newNode = address(0x9ABC);
        DataTypes.NodeRegion newRegion = DataTypes.NodeRegion.East;
        string memory newIpfs = "QmNewNode";

        vm.prank(admin);
        nodeManager.registerNewNode(newNode, newRegion, newIpfs);

        DataTypes.RegisteredNodes[] memory nodes = nodeManager
            .retrieveAllRegisteredNodeData();
        assertEq(nodes.length, 3);
        assertEq(nodes[2].nodeAddress, newNode);
        assertEq(uint(nodes[2].currentPosition), uint(newRegion));
        assertEq(nodes[2].IPFSData, newIpfs);
    }

    function testRegisterNewNodeNotAuthorized() public {
        address newNode = address(0x9ABC);
        DataTypes.NodeRegion newRegion = DataTypes.NodeRegion.East;
        string memory newIpfs = "QmNewNode";

        vm.expectRevert(Errors.NodeManager__CALLER_IS_NOT_AUTHORIZED.selector);
        nodeManager.registerNewNode(newNode, newRegion, newIpfs);
    }

    function testNodeAlreadyExists() public {
        vm.prank(admin);
        vm.expectRevert(Errors.NodeManager__NODE_ALREADY_EXIST.selector);
        nodeManager.registerNewNode(FIRST_COMMANDER, region1, ipfs1);
    }

    function testUpdateExpeditionaryForces() public {
        DataTypes.NodeRegion newRegion = DataTypes.NodeRegion.Central;

        vm.prank(admin);
        nodeManager.updateExpeditionaryForces(newRegion, FIRST_COMMANDER);

        DataTypes.RegisteredNodes[] memory nodes = nodeManager
            .retrieveAllRegisteredNodeData();
        assertEq(uint(nodes[0].currentPosition), uint(newRegion));
    }

    function testUpdateExpeditionaryForcesNotAuthorized() public {
        DataTypes.NodeRegion newRegion = DataTypes.NodeRegion.Central;

        vm.expectRevert(Errors.NodeManager__CALLER_IS_NOT_AUTHORIZED.selector);
        nodeManager.updateExpeditionaryForces(newRegion, FIRST_COMMANDER);
    }

    function testNumberOfPresentNodes() public {
        uint count = nodeManager.numberOfPresentNodes();
        assertEq(count, 2);
    }

    function testRetrieveAddressByIndex() public {
        address retrievedNode1 = nodeManager.retrieveAddressByIndex(0);
        address retrievedNode2 = nodeManager.retrieveAddressByIndex(1);

        assertEq(retrievedNode1, FIRST_COMMANDER);
        assertEq(retrievedNode2, SECOND_COMMANDER);
    }

    function testRegisterMultipleNewNodes() public {
        address newNode1 = address(0x1ABC);
        address newNode2 = address(0x2ABC);
        DataTypes.NodeRegion newRegion1 = DataTypes.NodeRegion.East;
        DataTypes.NodeRegion newRegion2 = DataTypes.NodeRegion.West;
        string memory newIpfs1 = "QmNewNode1";
        string memory newIpfs2 = "QmNewNode2";

        vm.prank(admin);
        nodeManager.registerNewNode(newNode1, newRegion1, newIpfs1);

        vm.prank(admin);
        nodeManager.registerNewNode(newNode2, newRegion2, newIpfs2);

        DataTypes.RegisteredNodes[] memory nodes = nodeManager
            .retrieveAllRegisteredNodeData();
        assertEq(nodes.length, 4);
        assertEq(nodes[2].nodeAddress, newNode1);
        assertEq(uint(nodes[2].currentPosition), uint(newRegion1));
        assertEq(nodes[2].IPFSData, newIpfs1);
        assertEq(nodes[3].nodeAddress, newNode2);
        assertEq(uint(nodes[3].currentPosition), uint(newRegion2));
        assertEq(nodes[3].IPFSData, newIpfs2);
    }

    function testRetrieveNodeDataByAddress() public {
        DataTypes.RegisteredNodes memory nodeData = nodeManager
            .retrieveNodeDataByAddress(FIRST_COMMANDER);
        assertEq(nodeData.nodeAddress, FIRST_COMMANDER);
        assertEq(uint(nodeData.currentPosition), uint(region1));
        assertEq(nodeData.IPFSData, ipfs1);
    }

    function testRetrieveNodeDataByAddressNotFound() public {
        vm.expectRevert(Errors.NodeManager__NODE_NOT_FOUND.selector);
        nodeManager.retrieveNodeDataByAddress(address(0x9999));
    }

    function testRetrieveAddressByIndexOutOfBounds() public {
        vm.expectRevert();
        nodeManager.retrieveAddressByIndex(999);
    }

    function testUpdateNodeIPFSData() public {
        string memory newIpfs = "QmUpdatedNode";
        vm.prank(admin);
        nodeManager.updateNodeIPFSData(FIRST_COMMANDER, newIpfs);
        DataTypes.RegisteredNodes memory nodeData = nodeManager
            .retrieveNodeDataByAddress(FIRST_COMMANDER);
        assertEq(nodeData.IPFSData, newIpfs);
    }
}
