// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {MinimalAccountAbstraction} from "../../contracts/ethereum/MinimalAccountAbstraction.sol";
import {HelperConfig} from "script/AccountAbstractionScripts/HelperConfig.s.sol";

contract AccountAbstractionScript is Script {
    MinimalAccountAbstraction private minimalAccountAbstraction;
    HelperConfig private helperConfig;
    address userAddress = makeAddr("minimalAccount");

    function run() external returns (MinimalAccountAbstraction) {
        vm.startBroadcast();
        vm.prank(userAddress);
        helperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        minimalAccountAbstraction = new MinimalAccountAbstraction(
            config.entryPoint
        );
        vm.stopBroadcast();
        return minimalAccountAbstraction;
    }
}
