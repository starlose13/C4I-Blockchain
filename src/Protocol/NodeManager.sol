// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;
import {INodeManager} from "../../interfaces/INodeManager.sol";

abstract contract NodeManager is INodeManager {
    uint256 hash;

    function registerNode() external {}
}
