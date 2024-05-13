// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;
import {INodeManager} from "../../interfaces/INodeManager.sol";
import {DataTypes} from "../Helper/DataTypes.sol";
import {Errors} from "../Helper/Errors.sol";

contract NodeManager {
    //Contract Admin that can change the structure of current smart contract later and manage the current system
    address immutable CONTRACT_ADMIN;
    mapping(address => DataTypes.RegisteredNodes) private s_registeredNodes;
    mapping(address => bool) private s_ExistingNodes;

    // mapping()
    constructor() {
        CONTRACT_ADMIN = msg.sender;
    }

    modifier onlyContractAdmin() {
        if (msg.sender != CONTRACT_ADMIN) {
            revert Errors.CALLER_IS_NOT_VALID_NODE();
        }
        _;
    }

    function registerNode(
        address _nodeAddress,
        string memory _currentPosition
    ) external onlyContractAdmin {
        DataTypes.RegisteredNodes memory registeredNodes = DataTypes
            .RegisteredNodes({
                node: _nodeAddress,
                currentPosition: _currentPosition
            });
        s_registeredNodes[msg.sender] = (registeredNodes);
        s_ExistingNodes[_nodeAddress] = true;
    }

    function unRegisterNode() external onlyContractAdmin {}

    function isNodeRegistered(
        address _nodeAddress
    ) external view returns (bool) {
        if (s_ExistingNodes[_nodeAddress] == true) {
            return true;
        }
        return false;
    }

    function updateExpeditionaryForces(
        string memory _expeditionaryForces
    ) external {
        s_registeredNodes[msg.sender].currentPosition = _expeditionaryForces;
    }
}
