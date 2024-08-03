// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.24;
// import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {Script} from "forge-std/Script.sol";
import {NodeManagerScript} from "../NodeManagerScripts/NodeManagerScript.s.sol";

contract UpgradeNodeManager is Script {
    NodeManagerScript public nodeMangerScript;

    function run() external {
        // address mostRecentUpgrade = DevOpsTools.get_most_recent_deployment(
        //     "ERC1967Proxy",
        //     block.chainid
        // );

        vm.startBroadcast();
        // 1.After write the new NodeManager Contract
        // 2.Deploy the UpgradeNodeManager Contract to change the Logic of the implementation
        vm.stopBroadcast();
    }
}
