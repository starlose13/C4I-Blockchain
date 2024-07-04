// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Test} from "forge-std/Test.sol";
import {NodeManager} from "../contracts/Protocol/NodeManager.sol";
import {DataTypes} from "../contracts/Helper/DataTypes.sol";
import {Errors} from "../contracts/Helper/Errors.sol";
import {NodeManagerScript} from "../script/NodeManagerScript.s.sol";

contract NodeManagerTest is Test {
    address private admin = address(0xABCD);
    address private immutable FIRST_COMMANDER = makeAddr("ALICE Commander");
    address private immutable SECOND_COMMANDER = makeAddr("BOB Commander");
    address private immutable THIRD_COMMANDER = makeAddr("JHON Commander");
    DataTypes.NodeRegion private region1 = DataTypes.NodeRegion.North;
    DataTypes.NodeRegion private region2 = DataTypes.NodeRegion.South;
    string private ipfs1 = "QmNode1";
    string private ipfs2 = "QmNode2";
    NodeManager private nodeManager;
    NodeManagerScript public nodeManagerScript;

    function setUp() public {
        nodeManagerScript = new NodeManagerScript();
        nodeManager = nodeManagerScript.run();

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

    function testInitialization() public {
        DataTypes.RegisteredNodes[] memory nodes = nodeManager
            .retrieveAllRegisteredNodeData();
        assertEq(nodes.length, 2, "Incorrect number of nodes registered");

        assertEq(
            nodes[0].nodeAddress,
            FIRST_COMMANDER,
            "First node address mismatch"
        );
        assertEq(
            uint256(nodes[0].currentPosition),
            uint256(region1),
            "First node region mismatch"
        );
        assertEq(nodes[0].IPFSData, ipfs1, "First node IPFS data mismatch");

        assertEq(
            nodes[1].nodeAddress,
            SECOND_COMMANDER,
            "Second node address mismatch"
        );
        assertEq(
            uint256(nodes[1].currentPosition),
            uint256(region2),
            "Second node region mismatch"
        );
        assertEq(nodes[1].IPFSData, ipfs2, "Second node IPFS data mismatch");
    }

    function testRegisterNewNode() public {
        address newNode = address(0x9ABC);
        DataTypes.NodeRegion newRegion = DataTypes.NodeRegion.East;
        string memory newIpfs = "QmNewNode";

        vm.prank(admin);
        nodeManager.registerNewNode(newNode, newRegion, newIpfs);

        DataTypes.RegisteredNodes[] memory nodes = nodeManager
            .retrieveAllRegisteredNodeData();
        assertEq(nodes.length, 3, "Node not added correctly");

        assertEq(nodes[2].nodeAddress, newNode, "New node address mismatch");
        assertEq(
            uint256(nodes[2].currentPosition),
            uint256(newRegion),
            "New node region mismatch"
        );
        assertEq(nodes[2].IPFSData, newIpfs, "New node IPFS data mismatch");
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
        assertEq(
            uint256(nodes[0].currentPosition),
            uint256(newRegion),
            "Node region update failed"
        );
    }

    function testUpdateExpeditionaryForcesNotAuthorized() public {
        DataTypes.NodeRegion newRegion = DataTypes.NodeRegion.Central;

        vm.expectRevert(Errors.NodeManager__CALLER_IS_NOT_AUTHORIZED.selector);
        nodeManager.updateExpeditionaryForces(newRegion, FIRST_COMMANDER);
    }

    function testNumberOfPresentNodes() public {
        uint256 count = nodeManager.numberOfPresentNodes();
        assertEq(count, 2, "Number of present nodes mismatch");
    }

    function testRetrieveAddressByIndex() public {
        address retrievedNode1 = nodeManager.retrieveAddressByIndex(0);
        address retrievedNode2 = nodeManager.retrieveAddressByIndex(1);

        assertEq(
            retrievedNode1,
            FIRST_COMMANDER,
            "First node retrieval mismatch"
        );
        assertEq(
            retrievedNode2,
            SECOND_COMMANDER,
            "Second node retrieval mismatch"
        );
    }

    function testRetrieveAddressByIndexOutOfBounds() public {
        vm.expectRevert();
        nodeManager.retrieveAddressByIndex(10);
    }

    function testRetrieveNodeDataByAddressNotFound() public {
        vm.expectRevert(Errors.NodeManager__NODE_NOT_FOUND.selector);
        nodeManager.retrieveNodeDataByAddress(address(0x9999));
    }

    function testUpdateNodeIPFSData() public {
        string memory newIpfs = "QmUpdatedNode";
        vm.prank(admin);
        nodeManager.updateNodeIPFSData(FIRST_COMMANDER, newIpfs);

        DataTypes.RegisteredNodes memory nodeData = nodeManager
            .retrieveNodeDataByAddress(FIRST_COMMANDER);
        assertEq(nodeData.IPFSData, newIpfs, "IPFS data update failed");
    }

    function testConstructorArrayLengthMismatch() public {
        address[] memory nodes = new address[](2);
        nodes[0] = FIRST_COMMANDER;
        nodes[1] = SECOND_COMMANDER;

        DataTypes.NodeRegion[] memory regions = new DataTypes.NodeRegion[](1);
        regions[0] = region1;

        string[] memory ipfsData = new string[](2);
        ipfsData[0] = ipfs1;
        ipfsData[1] = ipfs2;

        vm.expectRevert(
            Errors.NodeManager__ARRAYS_LENGTH_IS_NOT_EQUAL.selector
        );
        new NodeManager(nodes, regions, ipfsData);
    }

    function testOnlyContractAdmin() public {
        DataTypes.NodeRegion newRegion = DataTypes.NodeRegion.Central;
        address newNode = address(0x9ABC);
        string memory newIpfs = "QmNewNode";

        // Test registerNewNode with non-admin
        vm.prank(FIRST_COMMANDER);
        vm.expectRevert(Errors.NodeManager__CALLER_IS_NOT_AUTHORIZED.selector);
        nodeManager.registerNewNode(newNode, newRegion, newIpfs);

        // Test updateExpeditionaryForces with non-admin
        vm.prank(FIRST_COMMANDER);
        vm.expectRevert(Errors.NodeManager__CALLER_IS_NOT_AUTHORIZED.selector);
        nodeManager.updateExpeditionaryForces(newRegion, FIRST_COMMANDER);
    }

    function testIsNodeRegistered() public {
        bool isRegistered = nodeManager.isNodeRegistered(FIRST_COMMANDER);
        assertTrue(isRegistered, "Node should be registered");

        address nonExistentNode = address(0x5678);
        isRegistered = nodeManager.isNodeRegistered(nonExistentNode);
        assertFalse(isRegistered, "Node should not be registered");
    }

    function testRetrieveAllRegisteredNodeDataWithZeroNodes() public {
        address[] memory initialAddresses = new address[](0);
        string[] memory IPFS = new string[](0);
        DataTypes.NodeRegion[] memory Type = new DataTypes.NodeRegion[](0);
        NodeManager emptyNodeManager = new NodeManager(
            initialAddresses,
            Type,
            IPFS
        );

        DataTypes.RegisteredNodes[] memory nodes = emptyNodeManager
            .retrieveAllRegisteredNodeData();
        assertEq(nodes.length, 0, "There should be no nodes registered");
    }

    function testNumberOfPresentNodesWithZeroNodes() public {
        address[] memory initialAddresses = new address[](0);
        string[] memory IPFS = new string[](0);
        DataTypes.NodeRegion[] memory Type = new DataTypes.NodeRegion[](0);
        NodeManager emptyNodeManager = new NodeManager(
            initialAddresses,
            Type,
            IPFS
        );

        uint256 count = emptyNodeManager.numberOfPresentNodes();
        assertEq(count, 0, "Number of present nodes should be zero");
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
        assertEq(nodes.length, 4, "Incorrect number of nodes registered");

        assertEq(
            nodes[2].nodeAddress,
            newNode1,
            "First new node address mismatch"
        );
        assertEq(
            uint256(nodes[2].currentPosition),
            uint256(newRegion1),
            "First new node region mismatch"
        );
        assertEq(
            nodes[2].IPFSData,
            newIpfs1,
            "First new node IPFS data mismatch"
        );

        assertEq(
            nodes[3].nodeAddress,
            newNode2,
            "Second new node address mismatch"
        );
        assertEq(
            uint256(nodes[3].currentPosition),
            uint256(newRegion2),
            "Second new node region mismatch"
        );
        assertEq(
            nodes[3].IPFSData,
            newIpfs2,
            "Second new node IPFS data mismatch"
        );
    }
}
