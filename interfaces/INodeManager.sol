// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;
import {DataTypes} from "../contracts/ethereum/Helper/DataTypes.sol";

interface INodeManager {
    function retrieveOwner() external view returns (address contractOwner);

    function retrieveAllRegisteredNodeData()
        external
        view
        returns (DataTypes.RegisteredNodes[] memory);

    function registerNewNode(
        address _nodeAddress,
        DataTypes.NodeRegion _currentPosition,
        string memory IPFS
    ) external;

    function updateExpeditionaryForces(
        DataTypes.NodeRegion expeditionaryForces,
        address _nodeAddress
    ) external;

    function numberOfPresentNodes() external view returns (uint count);

    function retrieveAddressByIndex(uint index) external view returns (address);

    function isNodeRegistered(address nodeAddress) external view returns (bool);

    // // Events
    event NodeRegistered(
        address indexed nodeAddress,
        DataTypes.NodeRegion currentPosition
    );
}
