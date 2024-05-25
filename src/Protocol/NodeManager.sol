// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;
import {INodeManager} from "../../interfaces/INodeManager.sol";
import {DataTypes} from "../Helper/DataTypes.sol";
import {Errors} from "../Helper/Errors.sol";

contract NodeManager is INodeManager {
    //Contract Admin that can change the structure of current smart contract later and manage the current system

    address immutable CONTRACT_ADMIN;
    // mapping()
    mapping(address => DataTypes.RegisteredNodes) private s_registeredNodes;
    mapping(address => bool) private s_ExistingNodes;

    address[] public s_nodes;

    constructor(
        address[] memory _nodeAddresses,
        DataTypes.NodeRegion[] memory _currentPosition,
        string[] memory IPFS
    ) {
        if (_nodeAddresses.length != _currentPosition.length) {
            revert Errors.NodeManager__ARRAYS_LENGTH_IS_NOT_EQUAL();
        }
        CONTRACT_ADMIN = msg.sender;
        _initializeNodes(_nodeAddresses, _currentPosition, IPFS);
    }

    modifier onlyContractAdmin() {
        if (msg.sender != CONTRACT_ADMIN) {
            revert Errors.NodeManager__CALLER_IS_NOT_AUTHORIZED();
        }
        _;
    }

    function _initializeNodes(
        address[] memory _nodeAddress,
        DataTypes.NodeRegion[] memory _currentPosition,
        string[] memory IPFS
    ) private {
        for (uint256 i = 0; i < _nodeAddress.length; i++) {
            _registerNode(_nodeAddress[i], _currentPosition[i], IPFS[i]);
        }
    }

    function _registerNode(
        address _nodeAddress,
        DataTypes.NodeRegion currentPosition,
        string memory IPFS
    ) private {
        s_registeredNodes[_nodeAddress] = DataTypes.RegisteredNodes({
            nodeAddress: _nodeAddress,
            currentPosition: currentPosition,
            IPFSData: IPFS
        });
        s_nodes.push(_nodeAddress);
        s_ExistingNodes[_nodeAddress] = true;
        emit NodeRegistered(_nodeAddress, currentPosition);
    }

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

    function registerNewNode(
        address _nodeAddress,
        DataTypes.NodeRegion _currentPosition,
        string memory IPFS
    ) external onlyContractAdmin {
        if (isNodeRegistered(_nodeAddress)) {
            revert Errors.NodeManager__NODE_ALREADY_EXIST();
        }
        _registerNode(_nodeAddress, _currentPosition, IPFS);
        emit NodeRegistered(_nodeAddress, _currentPosition);
    }

    function isNodeRegistered(address nodeAddress) public view returns (bool) {
        if (s_ExistingNodes[nodeAddress] == true) {
            return true;
        }
        return false;
    }

    function updateExpeditionaryForces(
        DataTypes.NodeRegion expeditionaryForces,
        address _nodeAddress
    ) external onlyContractAdmin {
        s_registeredNodes[_nodeAddress].currentPosition = expeditionaryForces;
    }

    function numberOfPresentNodes() external view returns (uint count) {
        return count = s_nodes.length;
    }

    function retrieveAddressByIndex(
        uint index
    ) external view returns (address) {
        return s_nodes[index];
    }
}
