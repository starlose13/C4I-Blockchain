// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;
import {INodeManager} from "../../interfaces/INodeManager.sol";
import {DataTypes} from "../Helper/DataTypes.sol";
import {Errors} from "../Helper/Errors.sol";

contract NodeManager is INodeManager {
    //Contract Admin that can change the structure of current smart contract later and manage the current system
    enum Region {
        North,
        South,
        East,
        West,
        Central
    }
    address immutable CONTRACT_ADMIN;
    mapping(address => DataTypes.RegisteredNodes) private s_registeredNodes;
    mapping(address => bool) private s_ExistingNodes;

    // mapping()
    constructor(
        address[] memory _nodeAddress,
        string[] memory _currentPosition
    ) {
        if (_nodeAddress.length != _currentPosition.length) {
            revert Errors.NodeManager__ARRAYS_LENGTH_IS_NOT_EQUAL();
        }
        CONTRACT_ADMIN = msg.sender;
        initializeNodes(_nodeAddress, _currentPosition);
    }

    modifier onlyContractAdmin() {
        if (msg.sender != CONTRACT_ADMIN) {
            revert Errors.NodeManager__CALLER_IS_NOT_VALID_NODE();
        }
        _;
    }

    function _initializeNodes(
        address[] memory _nodeAddress,
        string[] memory _currentPosition
    ) private {
        for (uint256 i = 0; i < _nodeAddress.length; i++) {
            _registerNode(_nodeAddress[i], _currentPosition[i]);
        }
    }

    function registerNewNode(
        address _nodeAddress,
        string memory currentPosition
    ) external onlyContractAdmin {
        if (_isNodeRegistered(_nodeAddress)) {
            revert Errors.NodeManager__NODE_ALREADY_EXIST();
        }
        _registerNode(_nodeAddress, currentPosition);
    }

    function _registerNode(
        address _nodeAddress,
        string memory currentPosition
    ) private {
        s_registeredNodes[_nodeAddress] = DataTypes.RegisteredNodes({
            node: _nodeAddress,
            currentPosition: currentPosition
        });
        s_existingNodes[_nodeAddress] = true;
        emit NodeRegistered(_nodeAddress, currentPosition);
    }

    function initializeNodes(
        address[] memory _nodeAddress,
        string[] memory _currentPosition
    ) private {
        for (uint i = 0; i < _nodeAddress.length; i++) {
            _registerNode(_nodeAddress[i], _currentPosition[i]);
        }
    }

    function registerNewNode(
        address _nodeAddress,
        string memory currentPosition
    ) external onlyContractAdmin {
        DataTypes.RegisteredNodes memory registeredNodes = DataTypes
            .RegisteredNodes({
                node: _nodeAddress,
                currentPosition: currentPosition
            });
        s_registeredNodes[msg.sender] = (registeredNodes);
        s_ExistingNodes[_nodeAddress] = true;
        emit NodeRegistered(_nodeAddress, currentPosition);
    }

    function isNodeRegistered(address nodeAddress) public view returns (bool) {
        if (s_ExistingNodes[nodeAddress] == true) {
            return true;
        }
        return false;
    }

    function updateExpeditionaryForces(
        string memory expeditionaryForces
    ) external {
        s_registeredNodes[msg.sender].currentPosition = expeditionaryForces;
    }
}
