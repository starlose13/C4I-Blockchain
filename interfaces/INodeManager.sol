// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

interface INodeManager {
    // Function for registering a new node
    // function registerNode(
    //     address _nodeAddress,
    //     string memory _currentPosition
    // ) external;

    // // Function for removing a registered node
    // function unRegisterNode(address _nodeAddress) external;

    // // Function for updating the number of expeditionary forces allocated to a mission
    // function updateExpeditionaryForces(uint256 _expeditionaryForces) external;

    // // Function for updating the current geographical position of a node
    // function updateCurrentGeographicalPosition(
    //     string memory _position
    // ) external;

    // // Function for updating the geographical position of the observed target by a node
    // function updateTargetGeographicalPosition(string memory _position) external;

    // // Function for updating the type of target declared by a node
    // function updateTargetType(string memory _type) external;

    // // View function to retrieve the number of expeditionary forces allocated to a mission
    // function getNodeExpeditionaryForces(
    //     address _nodeAddress
    // ) external view returns (uint256);

    // // View function to retrieve the current geographical position of a node
    // function getNodeCurrentGeographicalPosition(
    //     address _nodeAddress
    // ) external view returns (string memory);

    // // View function to retrieve the geographical position of the observed target by a node
    // function getNodeTargetGeographicalPosition(
    //     address _nodeAddress
    // ) external view returns (string memory);

    // // View function to retrieve the type of target declared by a node
    // function getNodeTargetType(
    //     address _nodeAddress
    // ) external view returns (string memory);

    // View function to check if a given address is registered as a node

    function isNodeRegistered(address nodeAddress) external view returns (bool);

    // // Events
    event NodeRegistered(address indexed nodeAddress, string currentPosition);

    // // Event emitted when a new node is registered
    // event NodeRegistered(address indexed nodeAddress);

    // // Event emitted when a node is removed
    // event NodeRemoved(address indexed nodeAddress);

    // // Event emitted when the number of expeditionary forces allocated to a node is updated
    // event ExpeditionaryForcesUpdated(
    //     address indexed nodeAddress,
    //     uint256 newExpeditionaryForces
    // );

    // // Event emitted when the current geographical position of a node is updated
    // event CurrentGeographicalPositionUpdated(
    //     address indexed nodeAddress,
    //     string newPosition
    // );

    // // Event emitted when the geographical position of the observed target by a node is updated
    // event TargetGeographicalPositionUpdated(
    //     address indexed nodeAddress,
    //     string newTargetPosition
    // );

    // // Event emitted when the type of target declared by a node is updated
    // event TargetTypeUpdated(address indexed nodeAddress, string newTargetType);
}
