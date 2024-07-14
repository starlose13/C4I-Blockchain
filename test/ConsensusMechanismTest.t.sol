// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {ConsensusMechanism} from "../contracts/ethereum/Protocol/ConsensusMechanism.sol"; // Adjust the path to your ConsensusMechanism contract
import {NodeManager} from "../contracts/ethereum/Protocol/NodeManager.sol"; // Adjust the path to your NodeManager contract
import {DataTypes} from "../contracts/ethereum/Helper/DataTypes.sol"; // Adjust the path to your DataTypes library
import {Errors} from "../contracts/ethereum/Helper/Errors.sol"; // Adjust the path to your Errors library

contract ConsensusMechanismTest is Test {
    ConsensusMechanism private consensusMechanism;
    NodeManager private nodeManager;

    // Initialize the Nodes and Admin node.
    address private admin = address(0xABCD);
    address private node1 = address(0x1234);
    address private node2 = address(0x5678);
    address private node3 = address(0x9ABC);

    // Initialize the Node's Regions
    DataTypes.NodeRegion private region1 = DataTypes.NodeRegion.North;
    DataTypes.NodeRegion private region2 = DataTypes.NodeRegion.South;
    DataTypes.NodeRegion private region3 = DataTypes.NodeRegion.West;

    // Initialize the Node's Extra information
    string private ipfs1 = "QmNode1";
    string private ipfs2 = "QmNode2";
    string private ipfs3 = "QmNode3";

    // Initialize the Target's Regions
    DataTypes.TargetZone private noTarget = DataTypes.TargetZone.None;
    DataTypes.TargetZone private target1 = DataTypes.TargetZone.EnemyBunkers;
    DataTypes.TargetZone private target2 =
        DataTypes.TargetZone.ArtilleryEmplacements;
    DataTypes.TargetZone private target3 =
        DataTypes.TargetZone.CommunicationTowers;
    DataTypes.TargetZone private target4 =
        DataTypes.TargetZone.ObservationPosts;

    // Minimum vote required to pass consensus
    uint8 private consensusThreshold = 2;

    function setUp() public {
        address[] memory nodes = new address[](3);
        nodes[0] = node1;
        nodes[1] = node2;
        nodes[2] = node3;

        DataTypes.NodeRegion[] memory regions = new DataTypes.NodeRegion[](3);
        regions[0] = region1;
        regions[1] = region2;
        regions[2] = region3;

        string[] memory ipfsData = new string[](3);

        ipfsData[0] = ipfs1;
        ipfsData[1] = ipfs2;
        ipfsData[2] = ipfs3;

        vm.prank(admin);
        nodeManager = new NodeManager(nodes, regions, ipfsData);

        vm.prank(admin);
        consensusMechanism = new ConsensusMechanism(
            consensusThreshold,
            address(nodeManager)
        );
    }

    function skipTime() internal {
        vm.warp(
            block.timestamp +
                consensusMechanism.fetchConsensusEpochTimeDuration() +
                1
        );
    }

    function testInitialization() public {
        assertEq(
            consensusMechanism.fetchConsensusThreshold(),
            consensusThreshold
        );
        assertEq(consensusMechanism.fetchPolicyCustodian(), admin);
        assertEq(consensusMechanism.fetchNumberOfEpoch(), 0);
        assertEq(nodeManager.numberOfPresentNodes(), 3);
    }

    function testReportTargetLocationAllOnTheSameOpinion() public {
        vm.prank(node1);
        consensusMechanism.reportTargetLocation(node1, target1);
        vm.prank(node1);
        vm.expectRevert(Errors.ConsensusMechanism__NODE_ALREADY_VOTED.selector);
        consensusMechanism.reportTargetLocation(node1, target1);
        vm.expectRevert(
            Errors.ConsensusMechanism__YOU_ARE_NOT_CORRECT_SENDER.selector
        );
        consensusMechanism.reportTargetLocation(node2, target1);
        vm.prank(node3);
        consensusMechanism.reportTargetLocation(node3, target1);
    }

    function testReportTargetLocationTwoOnTheSameOpinion() public {
        vm.prank(node1);
        consensusMechanism.reportTargetLocation(node1, target1);
        vm.prank(node2);
        consensusMechanism.reportTargetLocation(node2, target1);
        vm.prank(node3);
        consensusMechanism.reportTargetLocation(node3, target2);
    }

    function testReportTargetLocationAllHaveDiffOpinion() public {
        vm.prank(node1);
        consensusMechanism.reportTargetLocation(node1, target1);
        vm.prank(node2);
        consensusMechanism.reportTargetLocation(node2, target2);
        vm.prank(node3);
        consensusMechanism.reportTargetLocation(node3, target3);
    }

    function testConsensusAutomationExecutionForAllOnTheSameOpinion() external {
        testReportTargetLocationAllOnTheSameOpinion();
        skipTime();
        (bool isReached, uint256 finalTarget) = consensusMechanism
            .consensusAutomationExecution();
        assertEq(isReached, true);
        assertEq(finalTarget, uint256(target1));
    }

    function testConsensusAutomationExecutionTwoOnTheSameOpinion() external {
        testReportTargetLocationTwoOnTheSameOpinion();
        skipTime();
        (bool isReached, uint256 finalTarget) = consensusMechanism
            .consensusAutomationExecution();
        assertEq(isReached, true);
        assertEq(finalTarget, uint256(target1));
    }

    function testConsensusAutomationExecutionAllHaveDiffOpinion() external {
        testReportTargetLocationAllHaveDiffOpinion();
        skipTime();
        (bool isReached, uint256 finalTarget) = consensusMechanism
            .consensusAutomationExecution();
        assertEq(isReached, false);
        assertEq(finalTarget, uint256(noTarget));
    }

    function testReportTargetLocation() public {
        vm.prank(node1);
        consensusMechanism.reportTargetLocation(
            node1,
            DataTypes.TargetZone.EnemyBunkers
        );

        DataTypes.TargetLocation memory reportedLocation = consensusMechanism
            .fetchTargetLocation(node1);
        assertEq(
            uint256(reportedLocation.zone),
            uint256(DataTypes.TargetZone.EnemyBunkers)
        );
        assertEq(reportedLocation.reportedBy, node1);
        assertTrue(reportedLocation.isActive);
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

    function testDoubleVotingNotAllowed() public {
        vm.prank(node1);
        consensusMechanism.reportTargetLocation(
            node1,
            DataTypes.TargetZone.EnemyBunkers
        );

        vm.prank(node1);
        vm.expectRevert(Errors.ConsensusMechanism__NODE_ALREADY_VOTED.selector);
        consensusMechanism.reportTargetLocation(
            node1,
            DataTypes.TargetZone.EnemyBunkers
        );
    }

    function testOnlyRegisteredNodes() external {
        address newNode = address(0x123456);
        vm.prank(newNode);
        vm.expectRevert(
            Errors.ConsensusMechanism__NODE_NOT_REGISTERED.selector
        );
        consensusMechanism.reportTargetLocation(newNode, target1);
    }

    function testConsensusAutomationExecution() public {
        vm.prank(node1);
        consensusMechanism.reportTargetLocation(
            node1,
            DataTypes.TargetZone.EnemyBunkers
        );
        console.log("start time", consensusMechanism.fetchStartTime());

        vm.prank(node2);
        consensusMechanism.reportTargetLocation(
            node2,
            DataTypes.TargetZone.EnemyBunkers
        );
        vm.prank(node3);
        consensusMechanism.reportTargetLocation(
            node3,
            DataTypes.TargetZone.EnemyBunkers
        );

        vm.warp(block.timestamp + 2100 minutes);

        console.log("start time", consensusMechanism.fetchStartTime());
        console.log(
            "consensusEpochTimeDuration",
            consensusMechanism.fetchConsensusEpochTimeDuration()
        );
        assert(
            consensusMechanism.fetchStartTime() +
                consensusMechanism.fetchConsensusEpochTimeDuration() <=
                block.timestamp
        );
        (bool isReached, uint256 target) = consensusMechanism
            .consensusAutomationExecution();
        assertTrue(isReached);
        assertEq(target, uint256(DataTypes.TargetZone.EnemyBunkers));
    }

    function testMakingConsensusAutomationExecutionNotAtTime() public {
        vm.prank(node1);
        consensusMechanism.reportTargetLocation(
            node1,
            DataTypes.TargetZone.EnemyBunkers
        );

        vm.warp(block.timestamp + 30 seconds);

        vm.expectRevert(
            abi.encodeWithSignature("ConsensusMechanism__TIME_IS_NOT_REACHED()")
        );
        consensusMechanism.consensusAutomationExecution();
    }

    function testConsensusAutomationExecutionNoConsensus() public {
        vm.prank(node1);
        consensusMechanism.reportTargetLocation(
            node1,
            DataTypes.TargetZone.EnemyBunkers
        );

        vm.prank(node2);
        consensusMechanism.reportTargetLocation(
            node2,
            DataTypes.TargetZone.ArtilleryEmplacements
        );

        vm.warp(block.timestamp + 11 minutes);

        (bool isReached, uint256 target) = consensusMechanism
            .consensusAutomationExecution();
        assertFalse(isReached);
        assertEq(target, uint256(0));
    }

    function testModifyEpochDuration() public {
        uint256 newDuration = 20;
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
        uint64 newThreshold = 4;
        vm.prank(admin);
        vm.expectRevert(
            Errors.ConsensusMechanism__THRESHOLD_EXCEEDS_NODES.selector
        );
        consensusMechanism.modifyConsensusThreshold(newThreshold);
    }

    function testHasNodeParticipated() public {
        vm.prank(node1);
        consensusMechanism.reportTargetLocation(
            node1,
            DataTypes.TargetZone.EnemyBunkers
        );

        bool hasParticipated = consensusMechanism.hasNodeParticipated(node1);
        assertTrue(hasParticipated);

        hasParticipated = consensusMechanism.hasNodeParticipated(node2);
        assertFalse(hasParticipated);
    }

    function testResetToDefaults() public {
        vm.prank(node1);
        consensusMechanism.reportTargetLocation(
            node1,
            DataTypes.TargetZone.EnemyBunkers
        );
        vm.prank(node2);
        consensusMechanism.reportTargetLocation(
            node2,
            DataTypes.TargetZone.EnemyBunkers
        );
        vm.warp(block.timestamp + 12 minutes);
        (bool sucess, uint256 target) = consensusMechanism
            .consensusAutomationExecution();
        assertEq(sucess, true);
        assertEq(target, uint256(DataTypes.TargetZone.EnemyBunkers));
        assertEq(consensusMechanism.fetchNumberOfEpoch(), 1);
        assertTrue(consensusMechanism.isEpochNotStarted());
    }

    function testFetchPolicyCustodian() public {
        assertEq(consensusMechanism.fetchPolicyCustodian(), admin);
    }

    function testCheckUpkeep() public {
        bool upkeepNeeded = consensusMechanism.checkUpkeep("");
        assertFalse(upkeepNeeded);

        vm.warp(block.timestamp + 11 minutes);
        upkeepNeeded = consensusMechanism.checkUpkeep("");
        assertTrue(upkeepNeeded);
    }

    function testPerformUpkeep() public {
        vm.warp(block.timestamp + 11 minutes);
        consensusMechanism.performUpkeep("");

        assertEq(consensusMechanism.s_lastTimeStamp(), block.timestamp);
    }

    function testFetchEpochCounter() public {
        assertEq(consensusMechanism.fetchNumberOfEpoch(), 0);
    }

    function testFetchConsensusEpochTimeDuration() public {
        assertEq(
            consensusMechanism.fetchConsensusEpochTimeDuration(),
            1 minutes
        );
    }

    function testTargetLocationSimulation() external {
        vm.startPrank(node1);
        address[] memory nodes = new address[](3);
        nodes[0] = node1;
        nodes[1] = node2;
        nodes[2] = node3;

        DataTypes.TargetZone[] memory regions = new DataTypes.TargetZone[](3);
        regions[0] = DataTypes.TargetZone.ArtilleryEmplacements;
        regions[1] = DataTypes.TargetZone.ArtilleryEmplacements;
        regions[2] = DataTypes.TargetZone.ObservationPosts;
        consensusMechanism.TargetLocationSimulation(nodes, regions);

        vm.warp(block.timestamp + 1000 minutes);

        (bool isReached, uint256 target) = consensusMechanism
            .consensusAutomationExecution();
        assertTrue(isReached);
        assertEq(target, uint256(DataTypes.TargetZone.ArtilleryEmplacements));
        vm.stopPrank();
    }

    function testVotingOnConsensusAndAutomation() public {
        address[] memory nodes = new address[](3);
        nodes[0] = node1;
        nodes[1] = node2;
        nodes[2] = node3;

        DataTypes.TargetZone[] memory regions = new DataTypes.TargetZone[](3);
        regions[0] = DataTypes.TargetZone.ArtilleryEmplacements;
        regions[1] = DataTypes.TargetZone.CommunicationTowers;
        regions[2] = DataTypes.TargetZone.ObservationPosts;
        vm.prank(node1);
        consensusMechanism.TargetLocationSimulation(nodes, regions);
        vm.warp(block.timestamp + 1000 minutes);

        consensusMechanism.consensusAutomationExecution();
    }

    function testFailedReachingConsensus() external {
        address[] memory nodes = new address[](3);
        nodes[0] = node1;
        nodes[1] = node2;
        nodes[2] = node3;

        DataTypes.TargetZone[] memory regions = new DataTypes.TargetZone[](3);
        regions[0] = DataTypes.TargetZone.ArtilleryEmplacements;
        regions[1] = DataTypes.TargetZone.CommunicationTowers;
        regions[2] = DataTypes.TargetZone.ObservationPosts;

        vm.prank(node1);
        consensusMechanism.TargetLocationSimulation(nodes, regions);
        vm.warp(block.timestamp + 1 minutes);

        (bool isReached, uint256 target) = consensusMechanism
            .consensusAutomationExecution();
        console.log("show result of reach", isReached);
        console.log("target result is", target);
        console.log("target zone is", uint256(DataTypes.TargetZone.None));

        assertEq(isReached, false);
        assertEq(target, uint256(DataTypes.TargetZone.None));
        vm.stopPrank();
    }

    function testFetechStartTime() external {
        // console.log("Time is: ", consensusMechanism.fetchStartTime());
        // assertEq(block.timestamp, consensusMechanism.fetchStartTime());
        vm.warp(block.timestamp + 2 minutes);

        // assert(
        //     block.timestamp + 1 minutes >= consensusMechanism.fetchStartTime()
        // );

        address[] memory nodes = new address[](3);
        nodes[0] = node1;
        nodes[1] = node2;
        nodes[2] = node3;

        DataTypes.TargetZone[] memory regions = new DataTypes.TargetZone[](3);
        regions[0] = DataTypes.TargetZone.ArtilleryEmplacements;
        regions[1] = DataTypes.TargetZone.CommunicationTowers;
        regions[2] = DataTypes.TargetZone.ObservationPosts;
        vm.prank(node1);
        consensusMechanism.TargetLocationSimulation(nodes, regions);
        vm.warp(block.timestamp + 10000 minutes);

        consensusMechanism.consensusAutomationExecution();
        // console.log("Time is: ", consensusMechanism.fetchStartTime());
        // console.log("Block.timestamp is equal: ", block.timestamp);
        // assertEq(block.timestamp, consensusMechanism.fetchStartTime());
    }
}
