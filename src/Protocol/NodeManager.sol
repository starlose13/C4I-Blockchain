// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;
import {INodeManager} from "../../interfaces/INodeManager.sol";
import {DataTypes} from "../Helper/DataTypes.sol";
import {Errors} from "../Helper/Errors.sol";

contract NodeManager is INodeManager {
    //Contract Admin that can change the structure of current smart contract later and manage the current system
    address immutable CONTRACT_ADMIN;
    mapping(address => DataTypes.RegisteredNodes) private s_registeredNodes;
    mapping(address => bool) private s_ExistingNodes;

    // mapping()
    constructor(
        address[] memory _nodeAddress,
        string[] memory _currentPosition
    ) {
        CONTRACT_ADMIN = msg.sender;
        initializeNodes(_nodeAddress, _currentPosition);
    }

    modifier onlyContractAdmin() {
        if (msg.sender != CONTRACT_ADMIN) {
            revert Errors.CALLER_IS_NOT_VALID_NODE();
        }
        _;
    }

    function initializeNodes(
        address[] memory _nodeAddress,
        string[] memory _currentPosition
    ) private {
        for (uint i = 0; i < _nodeAddress.length; i++) {
            DataTypes.RegisteredNodes memory registeredNodes = DataTypes
                .RegisteredNodes({
                    node: _nodeAddress[i],
                    currentPosition: _currentPosition[i]
                });
            s_registeredNodes[_nodeAddress[i]] = (registeredNodes);
            s_ExistingNodes[_nodeAddress[i]] = true;
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
