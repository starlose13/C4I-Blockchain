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
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/Base64.sol";
import {Utils} from "../contracts/ethereum/Helper/Utils.sol";
import {ERC1967Proxy} from "lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";

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

    /**
     * @notice Test the initial setup of the NodeManager contract.
     * @dev Verifies that the NodeManager is initialized with the expected number of nodes.
     */
    function testNodeManagerInitialization() public {
        uint256 expectedValue = 7;
        assertEq(
            NodeManager(nodeManagerProxyContract).numberOfPresentNodes(),
            expectedValue,
            "Incorrect number of nodes registered"
        );
    }

    /**
     * @notice Test registering a new node with valid data.
     * @dev Registers a new node and checks if it is added correctly by verifying the length and properties of the node.
     */
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
        assertEq(nodes.length, 8, "Node not added correctly");
        assertEq(nodes[7].nodeAddress, newNode, "New node address mismatch");
        assertEq(
            uint256(nodes[7].currentPosition),
            uint256(newRegion),
            "New node region mismatch"
        );
        assertEq(
            nodes[7].nodePosition,
            newNodePosition,
            "New node IPFS data mismatch"
        );
    }

    /**
     * @notice Test registering a new node by an unauthorized address.
     * @dev Attempts to register a node from an unauthorized account and expects it to revert.
     */
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

    /**
     * @notice Test registering a node that already exists.
     * @dev Tries to register a node with an address that already exists in the system and expects it to revert.
     */
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

    /**
     * @notice Test updating the expeditionary forces of a node.
     * @dev Updates the node's region and verifies that the update has been applied correctly.
     */
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

    /**
     * @notice Test updating the expeditionary forces by an unauthorized address.
     * @dev Attempts to update a node's region from an unauthorized account and expects it to revert.
     */
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

    /**
     * @notice Test the number of current nodes in the system.
     * @dev Verifies that the number of present nodes matches the expected value.
     */
    function testNumberOfCurrentNodes() public {
        uint256 count = NodeManager(nodeManagerProxyContract)
            .numberOfPresentNodes();
        uint256 expectedValue = 7;
        assertEq(count, expectedValue, "Number of present nodes mismatch");
    }

    function testRetrieveAddressByIndexOutOfBounds() public {
        vm.expectRevert();
        NodeManager(nodeManagerProxyContract).retrieveAddressByIndex(10);
    }

    /**
     * @notice Test retrieving a node address by an out-of-bounds index.
     * @dev Attempts to retrieve a node address using an index that exceeds the current node count and expects it to revert.
     */
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

    /**
     * @notice Test whether a node is registered.
     * @dev Verifies that the `isNodeRegistered` function returns `true` for a registered node and `false` for a non-existent node.
     */
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

    function testURIDataFormatter() public {
        address nodeAddress = address(0x1234);
        DataTypes.NodeRegion region = DataTypes.NodeRegion.West;
        string memory nodePosition = "QmNodePosition";
        string memory latitude = "40.7128 N";
        string memory longitude = "74.0060 W";

        // Register a new node
        vm.prank(policyCustodian);
        NodeManager(nodeManagerProxyContract).registerNewNode(
            nodeAddress,
            region,
            nodePosition,
            latitude,
            longitude
        );

        // Generate expected JSON data
        string memory expectedJson = string(
            abi.encodePacked(
                "{",
                '"wallet_address":"',
                Utils.addressToString(nodeAddress),
                '",',
                '"position":"',
                nodePosition,
                '",',
                '"unit":{',
                '"name":"Bravo Commander"',
                "},",
                '"location":{',
                '"latitude":"',
                latitude,
                '",',
                '"longitude":"',
                longitude,
                '"',
                "},",
                '"communications":{',
                '"encryption":"AES-256"',
                "}",
                "}"
            )
        );

        // Encode JSON to Base64
        bytes memory jsonBytes = bytes(expectedJson);
        string memory expectedBase64 = Base64.encode(jsonBytes);

        // Generate expected Data URI
        string memory expectedURI = string(
            abi.encodePacked("data:application/json;base64,", expectedBase64)
        );

        // Test URIDataFormatter
        string memory actualURI = NodeManager(nodeManagerProxyContract)
            .URIDataFormatter(nodeAddress);
        assertEq(
            actualURI,
            expectedURI,
            "URIDataFormatter did not return expected URI"
        );
    }

    function testURIDataFormatterForNonExistentNode() public {
        address nonExistentNode = address(0x5678);

        // Expect revert for non-existent node
        vm.expectRevert(Errors.NodeManager__NODE_NOT_FOUND.selector);
        NodeManager(nodeManagerProxyContract).URIDataFormatter(nonExistentNode);
    }

    function testURIDataFormatterAfterUpdate() public {
        address nodeAddress = address(0x1234);
        DataTypes.NodeRegion region = DataTypes.NodeRegion.West;
        string memory initialPosition = "QmInitialPosition";
        string memory initialLatitude = "40.7128 N";
        string memory initialLongitude = "74.0060 W";

        // Register a new node
        vm.prank(policyCustodian);
        NodeManager(nodeManagerProxyContract).registerNewNode(
            nodeAddress,
            region,
            initialPosition,
            initialLatitude,
            initialLongitude
        );

        // Update node data
        string memory updatedPosition = "QmUpdatedPosition";
        string memory updatedLatitude = "41.7128 N";
        string memory updatedLongitude = "75.0060 W";
        vm.prank(policyCustodian);
        NodeManager(nodeManagerProxyContract).updateNodeData(
            nodeAddress,
            updatedPosition,
            updatedLatitude,
            updatedLongitude
        );

        // Generate expected JSON data
        string memory expectedJson = string(
            abi.encodePacked(
                "{",
                '"wallet_address":"',
                Utils.addressToString(nodeAddress),
                '",',
                '"position":"',
                updatedPosition,
                '",',
                '"unit":{',
                '"name":"Bravo Commander"',
                "},",
                '"location":{',
                '"latitude":"',
                updatedLatitude,
                '",',
                '"longitude":"',
                updatedLongitude,
                '"',
                "},",
                '"communications":{',
                '"encryption":"AES-256"',
                "}",
                "}"
            )
        );

        // Encode JSON to Base64
        bytes memory jsonBytes = bytes(expectedJson);
        string memory expectedBase64 = Base64.encode(jsonBytes);

        // Generate expected Data URI
        string memory expectedURI = string(
            abi.encodePacked("data:application/json;base64,", expectedBase64)
        );

        // Test URIDataFormatter
        string memory actualURI = NodeManager(nodeManagerProxyContract)
            .URIDataFormatter(nodeAddress);
        assertEq(
            actualURI,
            expectedURI,
            "URIDataFormatter did not return expected URI after update"
        );
    }

    // Testing updateNodeData
    function testUpdateNodeData() public {
        address nodeAddress = address(0x1234);
        DataTypes.NodeRegion region = DataTypes.NodeRegion.West;
        string memory nodePosition = "QmNodePosition";
        string memory latitude = "40.7128 N";
        string memory longitude = "74.0060 W";

        // Register a new node
        vm.prank(policyCustodian);
        NodeManager(nodeManagerProxyContract).registerNewNode(
            nodeAddress,
            region,
            nodePosition,
            latitude,
            longitude
        );

        // Update node data
        string memory newNodePosition = "QmNewNodePosition";
        string memory newLatitude = "41.7128 N";
        string memory newLongitude = "75.0060 W";
        vm.prank(policyCustodian);
        NodeManager(nodeManagerProxyContract).updateNodeData(
            nodeAddress,
            newNodePosition,
            newLatitude,
            newLongitude
        );

        // Verify updated data
        DataTypes.RegisteredNodes memory updatedNode = NodeManager(
            nodeManagerProxyContract
        ).retrieveAllRegisteredNodeData()[7];
        assertEq(
            updatedNode.nodePosition,
            newNodePosition,
            "Node position was not updated correctly"
        );
        assertEq(
            updatedNode.latitude,
            newLatitude,
            "Node latitude was not updated correctly"
        );
        assertEq(
            updatedNode.longitude,
            newLongitude,
            "Node longitude was not updated correctly"
        );
    }

    // Testing retrieveAllRegisteredNodeData
    function testRetrieveAllRegisteredNodeData() public {
        address nodeAddress1 = address(0x1234);
        address nodeAddress2 = address(0x5678);
        DataTypes.NodeRegion region1 = DataTypes.NodeRegion.West;
        DataTypes.NodeRegion region2 = DataTypes.NodeRegion.East;
        string memory nodePosition1 = "QmNodePosition1";
        string memory nodePosition2 = "QmNodePosition2";
        string memory latitude1 = "40.7128 N";
        string memory latitude2 = "41.7128 N";
        string memory longitude1 = "74.0060 W";
        string memory longitude2 = "75.0060 W";

        // Register two nodes
        vm.prank(policyCustodian);
        NodeManager(nodeManagerProxyContract).registerNewNode(
            nodeAddress1,
            region1,
            nodePosition1,
            latitude1,
            longitude1
        );
        vm.prank(policyCustodian);
        NodeManager(nodeManagerProxyContract).registerNewNode(
            nodeAddress2,
            region2,
            nodePosition2,
            latitude2,
            longitude2
        );

        // Retrieve all registered node data
        DataTypes.RegisteredNodes[] memory nodes = NodeManager(
            nodeManagerProxyContract
        ).retrieveAllRegisteredNodeData();

        assertEq(
            nodes.length,
            9,
            "The number of nodes retrieved does not match the expected"
        );
        assertEq(
            nodes[7].nodeAddress,
            nodeAddress1,
            "First node address mismatch"
        );
        assertEq(
            nodes[8].nodeAddress,
            nodeAddress2,
            "Second node address mismatch"
        );
    }

    // Testing retrieveOwner
    function testRetrieveOwner() public {
        address owner = NodeManager(nodeManagerProxyContract).retrieveOwner();
        assertEq(
            owner,
            policyCustodian,
            "The retrieved owner address does not match"
        );
    }

    // Testing getNodeAddresses
    function testGetNodeAddresses() public {
        address nodeAddress = address(0x1234);
        DataTypes.NodeRegion region = DataTypes.NodeRegion.West;
        string memory nodePosition = "QmNodePosition";
        string memory latitude = "40.7128 N";
        string memory longitude = "74.0060 W";

        // Register a new node
        vm.prank(policyCustodian);
        NodeManager(nodeManagerProxyContract).registerNewNode(
            nodeAddress,
            region,
            nodePosition,
            latitude,
            longitude
        );

        address[] memory nodeAddresses = NodeManager(nodeManagerProxyContract)
            .getNodeAddresses();
        assertEq(
            nodeAddresses.length,
            8,
            "The number of node addresses does not match the expected"
        );
        assertEq(
            nodeAddresses[7],
            nodeAddress,
            "The retrieved node address does not match the expected"
        );
    }

    // Testing that _initializeNodes works correctly
    function testInitializeNodes() public {
        address[] memory initialAddresses = new address[](1);
        DataTypes.NodeRegion[] memory regions = new DataTypes.NodeRegion[](1);
        string[] memory positions = new string[](1);
        string[] memory latitudes = new string[](1);
        string[] memory longitudes = new string[](1);
        address testAddress = address(0x1234);
        initialAddresses[0] = testAddress;
        regions[0] = DataTypes.NodeRegion.West;
        positions[0] = "QmNodePosition";
        latitudes[0] = "40.7128 N";
        longitudes[0] = "74.0060 W";

        // Deploy a new instance of NodeManager and initialize it
        NodeManager nodeManager = new NodeManager();
        ERC1967Proxy nodeManagerProxy = new ERC1967Proxy(
            address(nodeManager),
            ""
        );
        NodeManager(address(nodeManagerProxy)).initialize(
            initialAddresses,
            regions,
            positions,
            latitudes,
            longitudes
        );
    }

    // Additional test cases to further increase coverage
    function testInitializeNodesEmptyData() public {
        address[] memory initialAddresses = new address[](0);
        DataTypes.NodeRegion[] memory regions = new DataTypes.NodeRegion[](0);
        string[] memory positions = new string[](0);
        string[] memory latitudes = new string[](0);
        string[] memory longitudes = new string[](0);

        NodeManager nodeManager = new NodeManager();
        ERC1967Proxy nodeManagerProxy = new ERC1967Proxy(
            address(nodeManager),
            ""
        );
        NodeManager(address(nodeManagerProxy)).initialize(
            initialAddresses,
            regions,
            positions,
            latitudes,
            longitudes
        );

        DataTypes.RegisteredNodes[] memory nodes = NodeManager(
            address(nodeManagerProxy)
        ).retrieveAllRegisteredNodeData();
        assertEq(nodes.length, 0, "There should be no nodes registered");
    }
}
