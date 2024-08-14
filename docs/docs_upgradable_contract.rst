
# Upgradable Smart Contracts

## Introduction

This document provides an overview of the upgradable smart contracts used in the project. Leveraging OpenZeppelin and Chainlink libraries, these contracts ensure secure and efficient upgrades, address management, access control, and initialization. Key components include:

- **UUPSUpgradeable** from OpenZeppelin
- **AddressUpgradeable** from Chainlink
- **AccessControlUpgradeable** from OpenZeppelin
- **Initializable** from OpenZeppelin

## 1. Key Components

### UUPSUpgradeable

**Purpose**:  
The `UUPSUpgradeable` contract from OpenZeppelin supports upgradability by adhering to the Universal Upgradeable Proxy Standard (UUPS). This allows updating the contract's logic while preserving its state.

**Functionality**:
- **Upgradability**: Enables updating contract logic through a delegated upgrade mechanism, maintaining the contract's state during upgrades.

**Integration**:  
Implemented in both the Node Manager and Consensus Mechanism contracts to manage contract upgrades effectively.

![Proxy Contract](./_static/proxy-contract.png)  
*Description of the image*  
*Width: 600px*  
*Align: center*

### AddressUpgradeable

**Purpose**:  
The `AddressUpgradeable` contract from Chainlink provides utilities for managing addresses securely and efficiently.

**Functionality**:
- **Address Validation**: Includes functions to ensure address operations are secure and correct, preventing the use of invalid or malicious addresses.

**Integration**:  
Used across smart contracts to manage and validate addresses.

### AccessControlUpgradeable

**Purpose**:  
The `AccessControlUpgradeable` contract from OpenZeppelin provides a role-based access control mechanism, ensuring secure and controlled access to contract functions.

**Functionality**:
- **Role Management**: Manages roles and permissions within the contract, restricting access based on assigned roles.

**Integration**:  
Incorporated in the Node Manager and Consensus Mechanism contracts for managing access and enforcing security policies.

### Initializable

**Purpose**:  
The `Initializable` contract from OpenZeppelin manages the initialization of upgradable contracts, ensuring initialization occurs only once.

**Functionality**:
- **Initialization Management**: Prevents reinitialization by providing mechanisms for safe setup of contract state variables.

**Integration**:  
Used in both Node Manager and Consensus Mechanism contracts for proper initialization during deployment or upgrades.

## 2. Contract Relationships and Workflow

### Node Manager Contract

**Function**:  
Manages nodes within the network, including node registration and maintenance of node-related data.

**Initialization**:
```solidity
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
```
- **Details**: Initializes the Node Manager with node addresses, regions, and geographical data. Sets up the contract admin, upgrade role management, and initializes nodes.
- **Integration**: Utilizes `Initializable` for setup, `UUPSUpgradeable` for upgradability, and `Ownable` for ownership management.

### Consensus Mechanism Contract

**Function**:  
Handles the consensus process, including managing consensus thresholds and epochs.

**Initialization**:
```solidity
function initialize(
    uint8 _s_consensusThreshold,
    address nodeManagerContractAddress,
    address policyCustodian
) public initializer {
    __Ownable_init(policyCustodian);
    __UUPSUpgradeable_init();
    __AccessControl_init();
    UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    CONSENSUS_NOT_REACHED = 0;
    isEpochNotStarted = true;
    consensusEpochTimeDuration = 1 minutes;
    POLICY_CUSTODIAN = policyCustodian;
    s_lastTimeStamp = block.timestamp;
    s_consensusThreshold = _s_consensusThreshold;
    nodeManager = INodeManager(nodeManagerContractAddress);
}
```
- **Details**: Sets up the Consensus Mechanism with threshold values, node manager address, and policy custodian. Configures upgrade roles, epoch settings, and consensus state management.
- **Integration**: Employs `Initializable` for initialization, `UUPSUpgradeable` for contract upgrades, `AccessControlUpgradeable` for role management, and `Ownable` for ownership.

## 3. Ownership and Role Management

### Policy Custodian

- **Role**: The Policy Custodian address is the owner of the UUPS address. This role is crucial for managing contract upgrades and maintaining control over the upgrade process.

## 4. Summary

The upgradable smart contracts in this project are structured to support ongoing enhancements while maintaining operational integrity. By incorporating `UUPSUpgradeable`, `AddressUpgradeable`, `AccessControlUpgradeable`, and `Initializable`, these contracts provide a secure and efficient framework for managing upgrades, addresses, and access controls.

The **Policy Custodian** address, as the owner of the UUPS address, ensures proper management of upgrades. The `initialize` functions in both the Node Manager and Consensus Mechanism contracts set up the necessary parameters and roles, ensuring that each contract is configured correctly for its role within the system.

---
