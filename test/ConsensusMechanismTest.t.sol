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

    address public consensusProxyContract;
    address public nodeManagerProxyContract;
    address public policyCustodian;

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

        assertEq(initialNodeAddresses.length, 7);

        // Verify ConsensusMechanism data
        assertEq(consensusMechanism.fetchConsensusThreshold(), 3);
        assertEq(
            consensusMechanism.fetchNodeMangerProxyContractAddress(),
            nodeManagerProxyContract
        );
        assertEq(consensusMechanism.POLICY_CUSTODIAN(), policyCustodian);
    }

    function testSkipTime() public {
        uint256 startTime = block.timestamp;
        testConsensusReachedWithAllVote();
        uint256 startTimeOfContract = ConsensusMechanism(consensusProxyContract)
            .fetchStartTime();
        uint256 epochDuration = ConsensusMechanism(consensusProxyContract)
            .fetchConsensusEpochTimeDuration();
        uint256 expectedTimeMoved = block.timestamp + 1 minutes;
        uint256 acctualTimeMoved = startTimeOfContract + epochDuration;
        vm.warp(acctualTimeMoved);
        console.log("startTime :", startTime);
        console.log("startTimeOfContract:", startTimeOfContract);
        assertEq(startTimeOfContract, startTime);
        assertEq(epochDuration, 1 minutes);
        console.log("acctualTimeMoved:", acctualTimeMoved);
        console.log("expectedTimeMoved :", expectedTimeMoved);
        assertEq(acctualTimeMoved, expectedTimeMoved);
    }

    function skipOneMinute() public {
        uint256 startTimeOfContract = ConsensusMechanism(consensusProxyContract)
            .fetchStartTime();
        uint256 epochDuration = ConsensusMechanism(consensusProxyContract)
            .fetchConsensusEpochTimeDuration();
        uint256 acctualTimeMoved = startTimeOfContract + epochDuration + 1;
        vm.warp(acctualTimeMoved);
    }

    function testInitialization() public {
        uint256 expectedEpochNumber;
        uint256 expectedNumberOfPresentNodes = 7;
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
        skipOneMinute();
        (bool isReached, uint256 finalTarget) = ConsensusMechanism(
            consensusProxyContract
        ).consensusAutomationExecution();
        console.log("isReached:", isReached);
        console.log("finalTarget:", finalTarget);

        assertEq(isReached, true);
        assertEq(finalTarget, uint256(target1));
    }

    function testConsensusAutomationExecutionWithMaliciousButConsensusReached()
        external
    {
        testMaliciousNodesEnteredButConsensusReached();
        skipOneMinute();
        (bool isReached, uint256 finalTarget) = ConsensusMechanism(
            consensusProxyContract
        ).consensusAutomationExecution();
        assertEq(isReached, true);
        assertEq(finalTarget, uint256(target1));
    }

    function testConsensusAutomationExecutionMaliciousNodesIntruptConsensus()
        external
    {
        testMaliciousNodesEnteredButConsensusNotReached();
        skipOneMinute();
        (bool isReached, uint256 finalTarget) = ConsensusMechanism(
            consensusProxyContract
        ).consensusAutomationExecution();
        assertEq(isReached, false);
        assertEq(finalTarget, uint256(noTarget));
    }

    function testReportTargetLocationAuthorizeNodes() public {
        address[] memory initialNodeAddresses = NodeManager(
            nodeManagerProxyContract
        ).getNodeAddresses();
        vm.prank(initialNodeAddresses[0]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[0],
            DataTypes.TargetZone.EnemyBunkers
        );

        DataTypes.TargetLocation memory reportedLocation = ConsensusMechanism(
            consensusProxyContract
        ).fetchTargetLocation(initialNodeAddresses[0]);
        assertEq(
            uint256(reportedLocation.zone),
            uint256(DataTypes.TargetZone.EnemyBunkers)
        );
        assertEq(reportedLocation.reportedBy, initialNodeAddresses[0]);
        assertTrue(reportedLocation.isActive);
    }

    function testReportTargetLocationNotAuthorized() public {
        address[] memory initialNodeAddresses = NodeManager(
            nodeManagerProxyContract
        ).getNodeAddresses();
        vm.prank(initialNodeAddresses[1]);
        vm.expectRevert(
            Errors.ConsensusMechanism__YOU_ARE_NOT_CORRECT_SENDER.selector
        );
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[0],
            DataTypes.TargetZone.EnemyBunkers
        );
    }

    function testDoubleVotingNotAllowed() public {
        address[] memory initialNodeAddresses = NodeManager(
            nodeManagerProxyContract
        ).getNodeAddresses();
        vm.prank(initialNodeAddresses[0]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[0],
            DataTypes.TargetZone.EnemyBunkers
        );

        vm.prank(initialNodeAddresses[0]);
        vm.expectRevert(Errors.ConsensusMechanism__NODE_ALREADY_VOTED.selector);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[0],
            DataTypes.TargetZone.EnemyBunkers
        );
    }

    function testOnlyRegisteredNodes() external {
        address newNode = address(0x123456);
        vm.prank(newNode);
        vm.expectRevert(
            Errors.ConsensusMechanism__NODE_NOT_REGISTERED.selector
        );
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            newNode,
            target1
        );
    }

    function testMakingConsensusAutomationExecutionNotAtTime() public {
        testConsensusReachedWithAllVote();
        vm.warp(block.timestamp + 30 seconds);

        vm.expectRevert();
        ConsensusMechanism(consensusProxyContract)
            .consensusAutomationExecution();
    }

    function testModifyEpochDuration() public {
        uint256 newDuration = 20; // Equal 20 minutes
        address contractAdmin = NodeManager(nodeManagerProxyContract)
            .retrieveOwner();

        uint256 expectedEpochDuration = newDuration * 1 minutes;
        vm.prank(contractAdmin);
        ConsensusMechanism(consensusProxyContract).modifyEpochDuration(
            newDuration
        );
        uint256 accutualEpochDuration = ConsensusMechanism(
            consensusProxyContract
        ).fetchConsensusEpochTimeDuration();
        assertEq(accutualEpochDuration, expectedEpochDuration);
    }

    function testModifyConsensusThresholdByValidNode() public {
        uint64 newThreshold = 2;
        address contractAdmin = NodeManager(nodeManagerProxyContract)
            .retrieveOwner();
        vm.prank(contractAdmin);
        ConsensusMechanism(consensusProxyContract).modifyConsensusThreshold(
            newThreshold
        );
        uint64 actualThreshold = ConsensusMechanism(consensusProxyContract)
            .fetchConsensusThreshold();

        assertEq(actualThreshold, newThreshold);
    }

    function testModifyConsensusThresholdExceedsNodesOrByNotAuthorizeNode()
        public
    {
        address newNode = makeAddr("BoB");
        uint64 newThreshold = 8;
        address contractAdmin = NodeManager(nodeManagerProxyContract)
            .retrieveOwner();
        vm.prank(contractAdmin);
        vm.expectRevert(
            Errors.ConsensusMechanism__THRESHOLD_EXCEEDS_NODES.selector
        );
        ConsensusMechanism(consensusProxyContract).modifyConsensusThreshold(
            newThreshold
        );
        vm.prank(newNode);
        vm.expectRevert(
            Errors.ConsensusMechanism__ONLY_POLICY_CUSTODIAN.selector
        );
        ConsensusMechanism(consensusProxyContract).modifyConsensusThreshold(
            newThreshold
        );
    }

    function testHasNodeParticipated() public {
        address[] memory initialNodeAddresses = NodeManager(
            nodeManagerProxyContract
        ).getNodeAddresses();
        vm.prank(initialNodeAddresses[0]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[0],
            DataTypes.TargetZone.EnemyBunkers
        );

        bool hasParticipated = ConsensusMechanism(consensusProxyContract)
            .hasNodeParticipated(initialNodeAddresses[0]);
        assertTrue(hasParticipated);

        hasParticipated = ConsensusMechanism(consensusProxyContract)
            .hasNodeParticipated(initialNodeAddresses[1]);
        assertFalse(hasParticipated);
    }

    // t should solve
    function testResetToDefaults() public {
        address[] memory initialNodeAddresses = NodeManager(
            nodeManagerProxyContract
        ).getNodeAddresses();
        vm.prank(initialNodeAddresses[0]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[0],
            DataTypes.TargetZone.EnemyBunkers
        );
        console.log(
            "log of last epoch status ",
            ConsensusMechanism(consensusProxyContract).fetchEpochStatus()
        );
        vm.prank(initialNodeAddresses[1]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[1],
            DataTypes.TargetZone.EnemyBunkers
        );
        vm.prank(initialNodeAddresses[2]);
        ConsensusMechanism(consensusProxyContract).reportTargetLocation(
            initialNodeAddresses[2],
            DataTypes.TargetZone.EnemyBunkers
        );
        // testModifyConsensusThresholdByValidNode();
        skipOneMinute();
        (bool sucess, uint256 target) = ConsensusMechanism(
            consensusProxyContract
        ).consensusAutomationExecution();
        assertEq(sucess, true);
        assertEq(target, uint256(DataTypes.TargetZone.EnemyBunkers));
        assertEq(
            ConsensusMechanism(consensusProxyContract).fetchNumberOfEpoch(),
            1
        );
        // assertTrue(
        //     ConsensusMechanism(consensusProxyContract).fetchEpochStatus()
        // );
    }

    function testFetchPolicyCustodinAreSameInBothContracts() public {
        assertEq(
            ConsensusMechanism(consensusProxyContract).fetchPolicyCustodian(),
            NodeManager(nodeManagerProxyContract).retrieveOwner()
        );
    }

    function testCheckUpkeep() public {
        (bool upkeepNeeded, ) = ConsensusMechanism(consensusProxyContract)
            .checkUpkeep("");
        assertFalse(upkeepNeeded);

        vm.warp(block.timestamp + 11 minutes);
        (upkeepNeeded, ) = ConsensusMechanism(consensusProxyContract)
            .checkUpkeep("");
        assertTrue(upkeepNeeded);
    }

    function testFetchEpochCounter() public {
        assertEq(
            ConsensusMechanism(consensusProxyContract).fetchNumberOfEpoch(),
            0
        );
    }

    function testFetchConsensusEpochTimeDuration() public {
        assertEq(
            ConsensusMechanism(consensusProxyContract)
                .fetchConsensusEpochTimeDuration(),
            1 minutes
        );
    }

    function testTargetLocationSimulation() external {
        uint lenghtOfArray = NodeManager(nodeManagerProxyContract)
            .numberOfPresentNodes();

        DataTypes.RegisteredNodes[] memory nodes = NodeManager(
            nodeManagerProxyContract
        ).retrieveAllRegisteredNodeData();
        address[] memory listOfAddresses = new address[](lenghtOfArray);
        DataTypes.TargetZone[]
            memory listOfTargets = new DataTypes.TargetZone[](lenghtOfArray);
        for (uint i = 0; i < listOfAddresses.length; i++) {
            listOfAddresses[i] = nodes[i].nodeAddress;
        }
        for (uint i = 0; i < listOfTargets.length; i++) {
            listOfTargets[i] = target1;
        }
        vm.prank(nodes[0].nodeAddress);
        ConsensusMechanism(consensusProxyContract).TargetLocationSimulation(
            listOfAddresses,
            listOfTargets
        );
        skipOneMinute();
        (bool isReached, uint256 target) = ConsensusMechanism(
            consensusProxyContract
        ).consensusAutomationExecution();
        assertTrue(isReached);
        assertEq(target, uint256(DataTypes.TargetZone.EnemyBunkers));
    }
}
