// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {MinimalAccountAbstraction} from "../../contracts/ethereum/MinimalAccountAbstraction.sol";
import {IEntryPoint} from "lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";

contract AccountAbstractionScript is Script {
    MinimalAccountAbstraction private minimalAccountAbstraction;
    IEntryPoint private entryPoint;
    address userAddress = makeAddr("minimalAccount");

    function run() external returns (MinimalAccountAbstraction) {
        vm.startBroadcast();
        vm.prank(userAddress);
        minimalAccountAbstraction = new MinimalAccountAbstraction(
            address(entryPoint)
        );
        vm.stopBroadcast();
        return minimalAccountAbstraction;
    }
}
