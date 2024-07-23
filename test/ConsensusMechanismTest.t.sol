// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {ConsensusMechanism} from "../contracts/ethereum/Protocol/ConsensusMechanism.sol";
import {NodeManager} from "../contracts/ethereum/Protocol/NodeManager.sol";
import {DataTypes} from "../contracts/ethereum/Helper/DataTypes.sol";
import {Errors} from "../contracts/ethereum/Helper/Errors.sol";
import {IntegratedDeploymentScript} from "../script/IntegratedScripts/IntegratedDeploymentScript.s.sol";

contract ConsensusMechanismTest is Test {
    ConsensusMechanism private consensusMechanism;
    NodeManager private nodeManager;
    IntegratedDeploymentScript private deploymentScript;

    // Initialize the Nodes and Admin node.
    address private admin;
    address private immutable FIRST_COMMANDER = makeAddr("ALICE Commander");
    address private immutable SECOND_COMMANDER = makeAddr("BOB Commander");
    address private immutable THIRD_COMMANDER = makeAddr("JHON Commander");

    // Initialize the Node's Regions
    DataTypes.NodeRegion private region1 = DataTypes.NodeRegion.North;
    DataTypes.NodeRegion private region2 = DataTypes.NodeRegion.North;
    DataTypes.NodeRegion private region3 = DataTypes.NodeRegion.West;

    // Initialize the Node's Extra information
    string private ipfs1 = "Position 1";
    string private ipfs2 = "Position 2";
    string private ipfs3 = "Position 3";

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
    uint8 private consensusThreshold = 3;

    address private consensusProxyContract;
    address private nodeManagerProxyContract;
    address private policyCustodian;

    function setUp() public {
        deploymentScript = new IntegratedDeploymentScript();
        (
            consensusProxyContract,
            nodeManagerProxyContract,
            policyCustodian
        ) = deploymentScript.run();
    }

    function testDeployAndVerify() public {
        consensusMechanism = ConsensusMechanism(consensusProxyContract);

        // Verify NodeManager data
        address[] memory initialNodeAddresses = NodeManager(
            nodeManagerProxyContract
        ).getNodeAddresses();

        assertEq(initialNodeAddresses.length, 6);

        assertEq(
            initialNodeAddresses[0],
            address(uint160(uint256(keccak256("Alice"))))
        );
        assertEq(
            initialNodeAddresses[1],
            address(uint160(uint256(keccak256("Bob"))))
        );
        assertEq(
            initialNodeAddresses[2],
            address(uint160(uint256(keccak256("Carol"))))
        );
        assertEq(
            initialNodeAddresses[3],
            address(uint160(uint256(keccak256("Dave"))))
        );
        assertEq(
            initialNodeAddresses[4],
            address(uint160(uint256(keccak256("Eve"))))
        );
        assertEq(
            initialNodeAddresses[5],
            address(uint160(uint256(keccak256("Mallory"))))
        );

        // Verify ConsensusMechanism data
        assertEq(consensusMechanism.fetchConsensusThreshold(), 3);
        assertEq(
            consensusMechanism.fetchNodeMangerProxyContractAddress(),
            nodeManagerProxyContract
        );
        assertEq(consensusMechanism.POLICY_CUSTODIAN(), policyCustodian);
    }

    function testSkipTime() public {
        uint256 expectedTimeMoved = block.timestamp + 1 minutes;
        uint256 acctualTimeMoved = ConsensusMechanism(consensusProxyContract)
            .fetchStartTime() +
            ConsensusMechanism(consensusProxyContract)
                .fetchConsensusEpochTimeDuration() +
            1;
        vm.warp(acctualTimeMoved);
        console.log("acctualTimeMoved:", acctualTimeMoved);
        console.log("expectedTimeMoved :", expectedTimeMoved);
        assertEq(acctualTimeMoved, expectedTimeMoved);
    }

    function testInitialization() public {
        uint256 expectedEpochNumber;
        uint256 expectedNumberOfPresentNodes = 6;
        assertEq(
            ConsensusMechanism(consensusProxyContract)
                .fetchConsensusThreshold(),
            consensusThreshold
        );
        assertEq(
            ConsensusMechanism(consensusProxyContract).fetchPolicyCustodian(),
            policyCustodian
        );
        assertEq(
            ConsensusMechanism(consensusProxyContract).fetchNumberOfEpoch(),
            expectedEpochNumber
        );
        assertEq(
            NodeManager(nodeManagerProxyContract).numberOfPresentNodes(),
            expectedNumberOfPresentNodes
        );
    }

    function testConsensusReachedWithAllVote() public {
        address[] memory initialNodeAddresses = NodeManager(
            nodeManagerProxyContract
        ).getNodeAddresses();

        vm.prank(initialNodeAddresses[0]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[0],
            target1
        );
        vm.prank(initialNodeAddresses[1]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[1],
            target1
        );
        vm.prank(initialNodeAddresses[2]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[2],
            target1
        );

        vm.prank(initialNodeAddresses[3]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[3],
            target1
        );
        vm.prank(initialNodeAddresses[4]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[4],
            target1
        );
        vm.prank(initialNodeAddresses[5]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[5],
            target1
        );
        vm.prank(initialNodeAddresses[0]);
        vm.expectRevert(Errors.ConsensusMechanism__NODE_ALREADY_VOTED.selector);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[0],
            target1
        );
    }

    function testMaliciousNodesEnteredButConsensusReached() public {
        address[] memory initialNodeAddresses = NodeManager(
            nodeManagerProxyContract
        ).getNodeAddresses();
        vm.prank(initialNodeAddresses[0]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[0],
            target1
        );
        vm.prank(initialNodeAddresses[1]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[1],
            target1
        );
        vm.prank(initialNodeAddresses[2]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[2],
            target1
        );
        vm.prank(initialNodeAddresses[3]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[3],
            target2
        );
        vm.prank(initialNodeAddresses[4]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[4],
            target3
        );
        vm.prank(initialNodeAddresses[5]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[5],
            target3
        );
    }

    function testMaliciousNodesEnteredButConsensusNotReached() public {
        address[] memory initialNodeAddresses = NodeManager(
            nodeManagerProxyContract
        ).getNodeAddresses();
        vm.prank(initialNodeAddresses[0]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[0],
            target1
        );
        vm.prank(initialNodeAddresses[1]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[1],
            target1
        );
        vm.prank(initialNodeAddresses[2]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[2],
            target2
        );
        vm.prank(initialNodeAddresses[3]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[3],
            target2
        );
        vm.prank(initialNodeAddresses[4]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[4],
            target3
        );
        vm.prank(initialNodeAddresses[5]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[5],
            target3
        );
    }

    function testConsensusAutomationExecutionForAllOnTheSameOpinion() external {
        testConsensusReachedWithAllVote();
        testSkipTime();
        (bool isReached, uint256 finalTarget) = ConsensusMechanism(
            consensusProxyContract
        ).consensusAutomationExecution();
        console.log("isReached:", isReached);
        console.log("finalTarget:", finalTarget);

        assertEq(isReached, true);
        assertEq(finalTarget, uint256(target1));
    }

    // function testConsensusAutomationExecutionTwoOnTheSameOpinion() external {
    //     testReportTargetLocationTwoOnTheSameOpinion();
    //     testSkipTime();
    //     (bool isReached, uint256 finalTarget) = consensusMechanism
    //         .consensusAutomationExecution();
    //     assertEq(isReached, true);
    //     assertEq(finalTarget, uint256(target1));
    // }

    // function testConsensusAutomationExecutionAllHaveDiffOpinion() external {
    //     testReportTargetLocationAllHaveDiffOpinion();
    //     testSkipTime();
    //     (bool isReached, uint256 finalTarget) = consensusMechanism
    //         .consensusAutomationExecution();
    //     assertEq(isReached, false);
    //     assertEq(finalTarget, uint256(noTarget));
    // }

    function testReportTargetLocation() public {
        vm.prank(FIRST_COMMANDER);
        consensusMechanism.reportTargetLocation(
            FIRST_COMMANDER,
            DataTypes.TargetZone.EnemyBunkers
        );

        DataTypes.TargetLocation memory reportedLocation = consensusMechanism
            .fetchTargetLocation(FIRST_COMMANDER);
        assertEq(
            uint256(reportedLocation.zone),
            uint256(DataTypes.TargetZone.EnemyBunkers)
        );
        assertEq(reportedLocation.reportedBy, FIRST_COMMANDER);
        assertTrue(reportedLocation.isActive);
    }

    function testReportTargetLocationNotAuthorized() public {
        vm.prank(SECOND_COMMANDER);
        vm.expectRevert(
            Errors.ConsensusMechanism__YOU_ARE_NOT_CORRECT_SENDER.selector
        );
        consensusMechanism.reportTargetLocation(
            FIRST_COMMANDER,
            DataTypes.TargetZone.EnemyBunkers
        );
    }

    function testDoubleVotingNotAllowed() public {
        vm.prank(FIRST_COMMANDER);
        consensusMechanism.reportTargetLocation(
            FIRST_COMMANDER,
            DataTypes.TargetZone.EnemyBunkers
        );

        vm.prank(FIRST_COMMANDER);
        vm.expectRevert(Errors.ConsensusMechanism__NODE_ALREADY_VOTED.selector);
        consensusMechanism.reportTargetLocation(
            FIRST_COMMANDER,
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
        vm.prank(FIRST_COMMANDER);
        consensusMechanism.reportTargetLocation(
            FIRST_COMMANDER,
            DataTypes.TargetZone.EnemyBunkers
        );
        console.log("start time", consensusMechanism.fetchStartTime());

        vm.prank(SECOND_COMMANDER);
        consensusMechanism.reportTargetLocation(
            SECOND_COMMANDER,
            DataTypes.TargetZone.EnemyBunkers
        );
        vm.prank(THIRD_COMMANDER);
        consensusMechanism.reportTargetLocation(
            THIRD_COMMANDER,
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
        vm.prank(FIRST_COMMANDER);
        consensusMechanism.reportTargetLocation(
            FIRST_COMMANDER,
            DataTypes.TargetZone.EnemyBunkers
        );

        vm.warp(block.timestamp + 30 seconds);

        vm.expectRevert(
            abi.encodeWithSignature("ConsensusMechanism__TIME_IS_NOT_REACHED()")
        );
        consensusMechanism.consensusAutomationExecution();
    }

    function testConsensusAutomationExecutionNoConsensus() public {
        vm.prank(FIRST_COMMANDER);
        consensusMechanism.reportTargetLocation(
            FIRST_COMMANDER,
            DataTypes.TargetZone.EnemyBunkers
        );

        vm.prank(SECOND_COMMANDER);
        consensusMechanism.reportTargetLocation(
            SECOND_COMMANDER,
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
        vm.prank(FIRST_COMMANDER);
        consensusMechanism.reportTargetLocation(
            FIRST_COMMANDER,
            DataTypes.TargetZone.EnemyBunkers
        );

        bool hasParticipated = consensusMechanism.hasNodeParticipated(
            FIRST_COMMANDER
        );
        assertTrue(hasParticipated);

        hasParticipated = consensusMechanism.hasNodeParticipated(
            SECOND_COMMANDER
        );
        assertFalse(hasParticipated);
    }

    function testResetToDefaults() public {
        vm.prank(FIRST_COMMANDER);
        consensusMechanism.reportTargetLocation(
            FIRST_COMMANDER,
            DataTypes.TargetZone.EnemyBunkers
        );
        vm.prank(SECOND_COMMANDER);
        consensusMechanism.reportTargetLocation(
            SECOND_COMMANDER,
            DataTypes.TargetZone.EnemyBunkers
        );
        vm.warp(block.timestamp + 12 minutes);
        (bool sucess, uint256 target) = consensusMechanism
            .consensusAutomationExecution();
        assertEq(sucess, true);
        assertEq(target, uint256(DataTypes.TargetZone.EnemyBunkers));
        assertEq(consensusMechanism.fetchNumberOfEpoch(), 1);
        assertTrue(
            ConsensusMechanism(consensusProxyContract).isEpochNotStarted()
        );
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
        vm.startPrank(FIRST_COMMANDER);
        address[] memory nodes = new address[](3);
        nodes[0] = FIRST_COMMANDER;
        nodes[1] = SECOND_COMMANDER;
        nodes[2] = THIRD_COMMANDER;

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
        nodes[0] = FIRST_COMMANDER;
        nodes[1] = SECOND_COMMANDER;
        nodes[2] = THIRD_COMMANDER;

        DataTypes.TargetZone[] memory regions = new DataTypes.TargetZone[](3);
        regions[0] = DataTypes.TargetZone.ArtilleryEmplacements;
        regions[1] = DataTypes.TargetZone.CommunicationTowers;
        regions[2] = DataTypes.TargetZone.ObservationPosts;
        vm.prank(FIRST_COMMANDER);
        consensusMechanism.TargetLocationSimulation(nodes, regions);
        vm.warp(block.timestamp + 1000 minutes);

        consensusMechanism.consensusAutomationExecution();
    }

    function testFailedReachingConsensus() external {
        address[] memory nodes = new address[](3);
        nodes[0] = FIRST_COMMANDER;
        nodes[1] = SECOND_COMMANDER;
        nodes[2] = THIRD_COMMANDER;

        DataTypes.TargetZone[] memory regions = new DataTypes.TargetZone[](3);
        regions[0] = DataTypes.TargetZone.ArtilleryEmplacements;
        regions[1] = DataTypes.TargetZone.CommunicationTowers;
        regions[2] = DataTypes.TargetZone.ObservationPosts;

        vm.prank(FIRST_COMMANDER);
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
        nodes[0] = FIRST_COMMANDER;
        nodes[1] = SECOND_COMMANDER;
        nodes[2] = THIRD_COMMANDER;

        DataTypes.TargetZone[] memory regions = new DataTypes.TargetZone[](3);
        regions[0] = DataTypes.TargetZone.ArtilleryEmplacements;
        regions[1] = DataTypes.TargetZone.CommunicationTowers;
        regions[2] = DataTypes.TargetZone.ObservationPosts;
        vm.prank(FIRST_COMMANDER);
        consensusMechanism.TargetLocationSimulation(nodes, regions);
        vm.warp(block.timestamp + 10000 minutes);

        consensusMechanism.consensusAutomationExecution();
        // console.log("Time is: ", consensusMechanism.fetchStartTime());
        // console.log("Block.timestamp is equal: ", block.timestamp);
        // assertEq(block.timestamp, consensusMechanism.fetchStartTime());
    }
}

// the following codes should be deleted when setup function works correctly
//  address[] memory nodes = new address[](3);
//         nodes[0] = FIRST_COMMANDER;
//         nodes[1] = SECOND_COMMANDER;
//         nodes[2] = THIRD_COMMANDER;

//         DataTypes.NodeRegion[] memory regions = new DataTypes.NodeRegion[](3);
//         regions[0] = region1;
//         regions[1] = region2;
//         regions[2] = region3;

//         string[] memory ipfsData = new string[](3);

//         ipfsData[0] = ipfs1;
//         ipfsData[1] = ipfs2;
//         ipfsData[2] = ipfs3;

//         vm.prank(admin);
//         nodeManager = new NodeManager();

//         vm.prank(admin);
//         consensusMechanism = new ConsensusMechanism();
