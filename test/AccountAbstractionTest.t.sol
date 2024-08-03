// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {MinimalAccountAbstraction} from "../contracts/ethereum/Protocol/MinimalAccountAbstraction.sol";
import {AccountAbstractionScript} from "../script/AccountAbstractionScripts/DeployAccountAbstractionScript.s.sol";
import {HelperConfig} from "script/AccountAbstractionScripts/HelperConfig.s.sol";
import {ERC20Mock} from "lib/openzeppelin-contracts/contracts/mocks/token/ERC20Mock.sol";
import {Errors} from "../contracts/ethereum/Helper/Errors.sol";

contract AccountAbstractionTest is Test {
    ERC20Mock usdc;
    uint256 constant AMOUNT = 1e18;
    MinimalAccountAbstraction minimalAccountAbstraction;
    address randomUser = makeAddr("randomUser");
    HelperConfig helperConfig;

    function setUp() public {
        usdc = new ERC20Mock();
        AccountAbstractionScript accountAbstractionScript = new AccountAbstractionScript();
        (helperConfig, minimalAccountAbstraction) = accountAbstractionScript
            .run();
    }

    function testOwnerCanExecuteCommands() public {
        address dest = address(usdc);
        assertEq(usdc.balanceOf(address(minimalAccountAbstraction)), 0);
        uint256 value = 0;
        bytes memory functionData = abi.encodeWithSelector(
            ERC20Mock.mint.selector,
            address(minimalAccountAbstraction),
            AMOUNT
        );
        vm.prank(minimalAccountAbstraction.owner());
        minimalAccountAbstraction.execute(dest, value, functionData);
        console.log(usdc.balanceOf(address(minimalAccountAbstraction)));

        assertEq(usdc.balanceOf(address(minimalAccountAbstraction)), AMOUNT);
    }

    function testNonOwnerCannotExecuteCommands() external {
        address dest = address(usdc);
        uint256 value = 0;
        bytes memory functionData = abi.encodeWithSelector(
            ERC20Mock.mint.selector,
            address(minimalAccountAbstraction),
            AMOUNT
        );
        vm.prank(randomUser);
        vm.expectRevert(
            Errors.AccountAbstraction__NOT_FROM_ENTRYPOINT_OR_OWNER.selector
        );
        minimalAccountAbstraction.execute(dest, value, functionData);
        console.log(usdc.balanceOf(address(minimalAccountAbstraction)));
    }

}
