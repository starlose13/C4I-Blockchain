// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "forge-std/Test.sol";
import "../src/Protocol/ConsensusMechanism.sol"; // Adjust the path to your ConsensusMechanism contract
import "../src/Protocol/NodeManager.sol"; // Adjust the path to your NodeManager contract
import "../src/Helper/DataTypes.sol"; // Adjust the path to your DataTypes library
import "../src/Helper/Errors.sol"; // Adjust the path to your Errors library

contract ConsensusMechanismTest is Test {
    ConsensusMechanism private consensusMechanism;
    NodeManager private nodeManager;
    address private admin = address(0xABCD);
    address private node1 = address(0x1234);
    address private node2 = address(0x5678);
    DataTypes.NodeRegion private region1 = DataTypes.NodeRegion.North;
    DataTypes.NodeRegion private region2 = DataTypes.NodeRegion.South;
    string private ipfs1 = "QmNode1";
    string private ipfs2 = "QmNode2";
    uint8 private consensusThreshold = 1;

    function setUp() public {
        address[] memory nodes = new address[](2);
        nodes[0] = node1;
        nodes[1] = node2;

        DataTypes.NodeRegion[] memory regions = new DataTypes.NodeRegion[](2);
        regions[0] = region1;
        regions[1] = region2;

        string[] memory ipfsData = new string[](2);
        ipfsData[0] = ipfs1;
        ipfsData[1] = ipfs2;

        vm.prank(admin);
        nodeManager = new NodeManager(nodes, regions, ipfsData);

        vm.prank(admin);
        consensusMechanism = new ConsensusMechanism(
            consensusThreshold,
            address(nodeManager)
        );
    }

    function testInitialization() public {
        assertEq(
            consensusMechanism.fetchConsensusThreshold(),
            consensusThreshold
        );
        assertEq(consensusMechanism.fetchPolicyCustodian(), admin);
    }

    function testReportTargetLocation() public {
        vm.prank(node1);
        consensusMechanism.reportTargetLocation(
            node1,
            DataTypes.TargetZone.EnemyBunkers
        );
    }

    function testReportTargetLocationNotAuthorized() public {
        vm.prank(node2);
        vm.expectRevert(
            Errors.ConsensusMechanism__YOU_ARE_NOT_CORRECT_SENDER.selector
        );
        consensusMechanism.reportTargetLocation(
            node1,
            DataTypes.TargetZone.EnemyBunkers
        );
    }

    function testConsensusAutomationExecution() public {
        vm.prank(node1);
        consensusMechanism.reportTargetLocation(
            node1,
            DataTypes.TargetZone.EnemyBunkers
        );

        vm.warp(block.timestamp + 11 minutes);

        (bool isReached, uint target) = consensusMechanism
            .consensusAutomationExecution();
        assertTrue(isReached);
        assertEq(target, uint(DataTypes.TargetZone.EnemyBunkers));
    }

    function testConsensusAutomationExecutionNotTime() public {
        vm.prank(node1);
        consensusMechanism.reportTargetLocation(
            node1,
            DataTypes.TargetZone.EnemyBunkers
        );

        vm.warp(block.timestamp + 5 minutes);

        vm.expectRevert(bytes("It is not time to run yet,Execution Failed!"));
        consensusMechanism.consensusAutomationExecution();
    }

    function testModifyEpochDuration() public {
        uint newDuration = 20;
        vm.prank(admin);
        consensusMechanism.modifyEpochDuration(newDuration);

        assertEq(
            consensusMechanism.fetchConsensusEpochTimeDuration(),
            newDuration * 1 minutes
        );
    }

    function testModifyConsensusThreshold() public {
        uint64 newThreshold = 2;
        vm.prank(admin);
        consensusMechanism.modifyConsensusThreshold(newThreshold);

        assertEq(consensusMechanism.fetchConsensusThreshold(), newThreshold);
    }

    function testModifyConsensusThresholdExceedsNodes() public {
        uint64 newThreshold = 3;
        vm.prank(admin);
        vm.expectRevert(
            Errors.ConsensusMechanism__THRESHOLD_EXCEEDS_NODES.selector
        );
        consensusMechanism.modifyConsensusThreshold(newThreshold);
    }
}
