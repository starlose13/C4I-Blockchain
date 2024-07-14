// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.24;

import {Test} from "forge-std/Test.sol";
import {MinimalAccountAbstraction} from "../contracts/ethereum/Protocol/MinimalAccountAbstraction.sol";
import {AccountAbstractionScript} from "../script/AccountAbstractionScripts/DeployAccountAbstractionScript.s.sol";
import {HelperConfig} from "script/AccountAbstractionScripts/HelperConfig.s.sol";
import {ERC20Mock} from "lib/openzeppelin-contracts/contracts/mocks/token/ERC20Mock.sol";

contract AccountAbstractionTest is Test {
    uint256 constant AMOUNT = 1e18;
    MinimalAccountAbstraction minimalAccountAbstraction;

    function setUp() public {
        AccountAbstractionScript accountAbstractionScript = new AccountAbstractionScript();
        HelperConfig helperConfig;
        (helperConfig, minimalAccountAbstraction) = accountAbstractionScript
            .run();
    }

    //   address dest,
    //         uint256 value,
    //         bytes calldata functionData
    function testExecute() public {
        ERC20Mock usdc = new ERC20Mock();
        address dest = address(usdc);
        uint256 value = 0;
        bytes memory functionData = abi.encodeWithSelector(
            ERC20Mock.mint.selector,
            AMOUNT,
            address(minimalAccountAbstraction)
        );
        // vm.prank(address(minimalAccountAbstraction));
        vm.prank(minimalAccountAbstraction.owner());
        minimalAccountAbstraction.execute(dest, value, functionData);
    }
}
