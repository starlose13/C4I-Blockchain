// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {NodeManagerScript} from "../../script/NodeManagerScripts/NodeManagerScript.s.sol";
import {DataTypes} from "../../contracts/ethereum/Helper/DataTypes.sol";
import {ConsensusMechanism} from "../../contracts/ethereum/Protocol/ConsensusMechanism.sol";
import {ERC1967Proxy} from "lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {NodeManager} from "../../contracts/ethereum/Protocol/NodeManager.sol";

contract ConsensusMechanismScript is Script {
    uint8 private constant THRESHOLD = 3;

    function run()
        external
        returns (
            address consensusProxyContract,
            address nodeManagerProxyContract,
            address policyCustodian
        )
    {
        (
            consensusProxyContract,
            nodeManagerProxyContract,
            policyCustodian
        ) = deployConsensusMechanism();
        return (
            consensusProxyContract,
            nodeManagerProxyContract,
            policyCustodian
        );
    }

    function deployConsensusMechanism()
        public
        returns (
            address consensusProxyContract,
            address nodeManagerProxyContract,
            address policyCustodian
        )
    {
        // Allow cheatcodes for the address of NodeManagerScript
        address nodeManagerScriptAddress = address(new NodeManagerScript());
        vm.allowCheatcodes(nodeManagerScriptAddress);
        vm.startBroadcast();
        NodeManagerScript nodeManagerDeployer = NodeManagerScript(
            nodeManagerScriptAddress
        );
        address nodeManagerProxy = nodeManagerDeployer.run();
        policyCustodian = NodeManager(nodeManagerProxy).retrieveOwner();
        ConsensusMechanism consensusMechanism = new ConsensusMechanism();
        ERC1967Proxy consensusProxy = new ERC1967Proxy(
            address(consensusMechanism),
            ""
        );
        ConsensusMechanism(address(consensusProxy)).initialize(
            THRESHOLD,
            nodeManagerProxy,
            policyCustodian
        );
        vm.stopBroadcast();
        return (
            address(consensusProxy),
            address(nodeManagerProxy),
            policyCustodian
        );
    }
}
