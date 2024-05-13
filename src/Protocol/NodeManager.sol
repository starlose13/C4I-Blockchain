// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;
import {INodeManager} from "../../interfaces/INodeManager.sol";
import {DataTypes} from "../Helper/DataTypes.sol";
import {Errors} from "../Helper/Errors.sol";

contract NodeManager {
    //proxy admin user that can change the structure of current smart contract later
    address constant PROXY_ADMIN = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    mapping(address => DataTypes.RegisteredNodes) private s_registeredNodes;

    constructor() {}

    function registerNode() external {
        if (msg.sender != PROXY_ADMIN) {
            revert Errors.CALLER_NOT_IS_VALID_NODE();
        }
        DataTypes.RegisteredNodes memory registeredNodes = DataTypes
            .RegisteredNodes({node: msg.sender, currentPosition: ""});
        s_registeredNodes[msg.sender] = (registeredNodes);
    }
}
