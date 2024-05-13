// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;
import {Test, console} from "forge-std/Test.sol";

import {NodeManager} from "../src/Protocol/NodeManager.sol";
import {DataTypes} from "../src/Helper/DataTypes.sol";
import {Errors} from "../src/Helper/Errors.sol";
import {NodeManagerScript} from "../script/NodeManagerScript.s.sol";

contract NodeManagerTest is Test {
    NodeManager nodeManager;
    NodeManagerScript deplpoyNodeManager;
    address immutable FIRST_COMMANDER = makeAddr("ALICE Commander"); //first person who exercises authority chief officer; leader. the commissioned officer in command of a military unit
    address immutable SECOND_COMMANDER = makeAddr("BOB Commander"); //second person who exercises authority chief officer; leader. the commissioned officer in command of a military unit
    address immutable THIRD_COMMANDER = makeAddr("JHON Commander"); //third person who exercises authority chief officer; leader. the commissioned officer in command of a military unit

    function setUp() external {
        deplpoyNodeManager = new NodeManagerScript();
        nodeManager = deplpoyNodeManager.run();

        vm.deal(FIRST_COMMANDER, 100 ether);
        vm.deal(SECOND_COMMANDER, 100 ether);
        vm.deal(THIRD_COMMANDER, 100 ether);
    }

    function testRegisterNode() public {
        vm.expectRevert();
        vm.prank(FIRST_COMMANDER);
        nodeManager.registerNode();
    }
}
