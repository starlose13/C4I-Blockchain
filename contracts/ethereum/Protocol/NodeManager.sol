// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {INodeManager} from "../../../interfaces/INodeManager.sol";
import {DataTypes} from "../Helper/DataTypes.sol";
import {Errors} from "../Helper/Errors.sol";
import {OwnableUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import {AccessControlUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/access/AccessControlUpgradeable.sol";
import {AddressUpgradeable} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/vendor/openzeppelin-contracts-upgradeable/v4.8.1/utils/AddressUpgradeable.sol";
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/Base64.sol";
import {Utils} from "../Helper/Utils.sol";

/**
 * @title NodeManager
 * @author SunAir institue, University of Ferdowsi
 * @dev This contract manages the registration and data of nodes within a decentralized system.
 */
contract NodeManager is
    INodeManager,
    Initializable,
    UUPSUpgradeable,
    OwnableUpgradeable,
    AccessControlUpgradeable
{
    /*//////////////////////////////////////////////////////////////
                           STATE VARIABLES
    //////////////////////////////////////////////////////////////*/

    bytes32 private UPGRADER_ROLE;

    // Contract Admin who can modify the contract and manage the system
    address private CONTRACT_ADMIN;

    // Array to store all node addresses
    address[] internal s_nodes;

    /*//////////////////////////////////////////////////////////////
                               MAPPINGS
    //////////////////////////////////////////////////////////////*/

    // Mapping to store registered nodes and their data
    mapping(address => DataTypes.RegisteredNodes) private s_registeredNodes;

    // Mapping to check if a node is already registered
    mapping(address => bool) private s_ExistingNodes;

    /*//////////////////////////////////////////////////////////////
                             CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor() {
        _disableInitializers();
    }

    /**
     * @dev Constructor to initialize the contract with initial nodes.
     * @param _nodeAddresses Array of node addresses to be registered initially.
     * @param _currentPosition Array of node regions corresponding to the addresses.
     * @param nodePosition Array of locations corresponding to the node data.
     */
    function initialize(
        address[] memory _nodeAddresses,
        DataTypes.NodeRegion[] memory _currentPosition,
        string[] memory nodePosition,
        string[] memory latitude,
        string[] memory longitude
    ) public initializer {
        if (_nodeAddresses.length != _currentPosition.length) {
            revert Errors.ARRAYS_LENGTH_IS_NOT_EQUAL();
        }
        CONTRACT_ADMIN = msg.sender;
        UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
        __Ownable_init(CONTRACT_ADMIN);
        _initializeNodes(
            _nodeAddresses,
            _currentPosition,
            nodePosition,
            latitude,
            longitude
        );
        __UUPSUpgradeable_init();
    }

    /*//////////////////////////////////////////////////////////////
                              MODIFIERS
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Modifier to restrict functions to only the contract admin.
     */
    modifier onlyContractAdmin() {
        if (msg.sender != CONTRACT_ADMIN) {
            revert Errors.NodeManager__CALLER_IS_NOT_AUTHORIZED();
        }
        _;
    }

    /**
     * @dev Modifier to restrict address(0) call functions.
     */

    modifier notZeroAddress(address sender) {
        if (sender == address(0)) {
            revert Errors.NOT_ZERO_ADDRESS_ALLOWED();
        }
        _;
    }

    /*//////////////////////////////////////////////////////////////
                              FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                          INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function _authorizeUpgrade(
        address newImplementation
    ) internal view override onlyRole(UPGRADER_ROLE) {
        if (msg.sender != CONTRACT_ADMIN) {
            revert Errors.NodeManager__CALLER_IS_NOT_AUTHORIZED();
        }
        if (!AddressUpgradeable.isContract(newImplementation)) {
            revert Errors.NodeManager__CALLER_IS_NOT_AUTHORIZED();
        }
    }

    /**
     * @dev Internal function to initialize nodes during contract deployment.
     * @param _nodeAddress Array of node addresses to be registered.
     * @param _currentPosition Array of node regions corresponding to the addresses.
     * @param nodePosition Array of nodePosition  corresponding to the node data.
     */

    function _initializeNodes(
        address[] memory _nodeAddress,
        DataTypes.NodeRegion[] memory _currentPosition,
        string[] memory nodePosition,
        string[] memory latitude,
        string[] memory longitude
    ) internal {
        for (uint256 i = 0; i < _nodeAddress.length; i++) {
            _registerNode(
                _nodeAddress[i],
                _currentPosition[i],
                nodePosition[i],
                latitude[i],
                longitude[i]
            );
        }
    }

    /**
     * @dev Internal function to register a node.
     * @param _nodeAddress Address of the node to be registered.
     * @param currentPosition Region of the node.
     */

    function _registerNode(
        address _nodeAddress,
        DataTypes.NodeRegion currentPosition,
        string memory nodePosition,
        string memory latitude,
        string memory longitude
    ) internal notZeroAddress(_nodeAddress) {
        s_registeredNodes[_nodeAddress] = DataTypes.RegisteredNodes({
            nodeAddress: _nodeAddress,
            currentPosition: currentPosition,
            nodePosition: nodePosition,
            latitude: latitude,
            longitude: longitude
        });
        s_nodes.push(_nodeAddress);
        s_ExistingNodes[_nodeAddress] = true;
        emit NodeRegistered(_nodeAddress, currentPosition);
    }

    /*//////////////////////////////////////////////////////////////
                     PUBLIC & EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Updates the logistic information  of a node.
     * @param _nodeAddress Address of the node to update.
     * @param newNodePosition New position of node location.
     * @param newLatitude change the latitude of the node location. In geography, latitude is a coordinate that specifies the north–south position of a point on the surface of the Earth or another celestial body.
     * @param newLongitude change the longitude of the node location. Longitude is a geographic coordinate that specifies the east–west position of a point on the surface of the Earth, or another celestial body
     */
    function updateNodeData(
        address _nodeAddress,
        string memory newNodePosition,
        string memory newLatitude,
        string memory newLongitude
    ) external onlyContractAdmin notZeroAddress(_nodeAddress) {
        if (!isNodeRegistered(_nodeAddress)) {
            revert Errors.NodeManager__NODE_NOT_FOUND();
        }
        s_registeredNodes[_nodeAddress].nodePosition = newNodePosition;
        s_registeredNodes[_nodeAddress].latitude = newLatitude;
        s_registeredNodes[_nodeAddress].longitude = newLongitude;
    }

    /**
     * @dev Registers a new node if it's not already registered.
     * @param _nodeAddress Address of the new node.
     * @param _currentPosition Position of the new node.
     */

    function registerNewNode(
        address _nodeAddress,
        DataTypes.NodeRegion _currentPosition,
        string memory nodePosition,
        string memory latitude,
        string memory longitude
    ) external onlyContractAdmin {
        if (isNodeRegistered(_nodeAddress)) {
            revert Errors.NodeManager__NODE_ALREADY_EXIST();
        }
        _registerNode(
            _nodeAddress,
            _currentPosition,
            nodePosition,
            latitude,
            longitude
        );
        emit NodeRegistered(_nodeAddress, _currentPosition);
    }

    /**
     * @dev Updates the position of a node.
     * @param expeditionaryForces New position of the node.
     * @param _nodeAddress Address of the node to update.
     */

    function updateExpeditionaryForces(
        DataTypes.NodeRegion expeditionaryForces,
        address _nodeAddress
    ) external onlyContractAdmin notZeroAddress(_nodeAddress) {
        s_registeredNodes[_nodeAddress].currentPosition = expeditionaryForces;
    }

    /*//////////////////////////////////////////////////////////////
                               GETTERS
    //////////////////////////////////////////////////////////////*/
    /**
     * @dev Checks if a node is already registered.
     * @param nodeAddress Address of the node to check.
     * @return Boolean indicating if the node is registered.
     */

    function isNodeRegistered(address nodeAddress) public view returns (bool) {
        if (s_ExistingNodes[nodeAddress] == true) {
            return true;
        }
        return false;
    }

    /**
     * @dev Returns the number of registered nodes.
     * @return count Count of registered nodes.
     */

    function numberOfPresentNodes() external view returns (uint256 count) {
        return count = s_nodes.length;
    }

    /**
     * @dev Retrieves a node address by its index.
     * @param index Index of the node address to retrieve.
     * @return Address of the node.
     */
    function retrieveAddressByIndex(
        uint256 index
    ) external view returns (address) {
        return s_nodes[index];
    }

    /**
     * @dev Retrieves node data by its address.
     * @param _nodeAddress Address of the node to retrieve data for.
     * @return RegisteredNodes struct containing node data.
     */

    function retrieveNodeDataByAddress(
        address _nodeAddress
    ) external view returns (DataTypes.RegisteredNodes memory) {
        if (!isNodeRegistered(_nodeAddress)) {
            revert Errors.NodeManager__NODE_NOT_FOUND();
        }
        return s_registeredNodes[_nodeAddress];
    }

    /**
     * @dev Retrieves data of all registered nodes.
     * @return Array of RegisteredNodes structs.
     */
    function retrieveAllRegisteredNodeData()
        external
        view
        returns (DataTypes.RegisteredNodes[] memory)
    {
        DataTypes.RegisteredNodes[]
            memory result = new DataTypes.RegisteredNodes[](s_nodes.length);
        for (uint256 i; i < s_nodes.length; i++) {
            result[i] = s_registeredNodes[s_nodes[i]];
        }
        return result;
    }

    function retrieveOwner() external view returns (address contractOwner) {
        return CONTRACT_ADMIN;
    }

    function getNodeAddresses() external view returns (address[] memory) {
        return s_nodes;
    }

    // function fetchLatitude(address user) external view returns (string memory) {
    //     return s_registeredNodes[user].latitude;
    // }

    // function fetchLongitude(
    //     address user
    // ) external view returns (string memory) {
    //     return s_registeredNodes[user].longitude;
    // }

    // function fetchNodePosition(
    //     address user
    // ) external view returns (string memory) {
    //     return s_registeredNodes[user].nodePosition;
    // }

    function _baseURI() internal pure returns (string memory) {
        return "data:application/json;base64,";
    }

    /**
     * @notice Returns a Data URI containing encoded JSON data with user and unit information
     * @param user The address of the user for whom the data URI is generated
     * @return The Data URI string containing JSON-encoded dat
     */
    // function URIDataFormatter(
    //     address user
    // ) public view returns (string memory) {
    //     DataTypes.RegisteredNodes storage node = s_registeredNodes[user];
    //     require(node.nodeAddress != address(0), "Node not found");
    //     return
    //         string(
    //             abi.encodePacked(
    //                 _baseURI(),
    //                 Base64.encode(
    //                     abi.encodePacked(
    //                         "{",
    //                         '"wallet_address":"',
    //                         Utils.addressToString(user),
    //                         '",',
    //                         '"register_time":"',
    //                         Utils.uint256ToString(block.timestamp), // Assuming you want the current timestamp
    //                         '",',
    //                         '"unit":{',
    //                         '"name":"Bravo Commander"',
    //                         "},",
    //                         '"location":{',
    //                         '"latitude":"',
    //                         node.latitude,
    //                         '",',
    //                         '"longitude":"',
    //                         node.longitude,
    //                         "},",
    //                         '"communications":{',
    //                         '"encryption":"AES-256"',
    //                         "}",
    //                         "}"
    //                     )
    //                 )
    //             )
    //         );
    // }

    function URIDataFormatter(
        address user
    ) public view returns (string memory) {
        DataTypes.RegisteredNodes storage node = s_registeredNodes[user];
        require(node.nodeAddress != address(0), "Node not found");

        string memory userEOA = Utils.addressToString(node.nodeAddress);
        string memory latitude = node.latitude;
        string memory longitude = node.longitude;
        string memory nodePosition = node.nodePosition;

        // Construct JSON string
        string memory json = string(
            abi.encodePacked(
                "{",
                '"wallet_address":"',
                userEOA,
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
        bytes memory jsonBytes = bytes(json);
        string memory base64Encoded = Base64.encode(jsonBytes);

        // Return Data URI
        return string(abi.encodePacked(_baseURI(), base64Encoded));
    }
}
