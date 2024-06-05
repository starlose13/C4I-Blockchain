// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NodeConsensus {
    // Node structure to hold information about nodes
    struct Node {
        address addr;
        bool isActive;
    }

    // Proposal structure to manage node proposals
    struct Proposal {
        address proposer;
        address nodeAddress;
        bool isAddition; // true if the proposal is to add a node, false to remove
        uint256 votesFor;
        uint256 votesAgainst;
        mapping(address => bool) voted; // to track if a node has voted
        bool isActive; // to mark if the proposal is still active
    }

    // Threshold for consensus
    uint256 public constant CONSENSUS_THRESHOLD = 3; // example threshold

    // Array to hold all nodes
    Node[] public nodes;

    // Mapping to store proposals
    mapping(uint256 => Proposal) public proposals;

    // Counter for proposals
    uint256 public proposalCount;

    // Events for logging actions
    event NodeProposed(
        address indexed proposer,
        address indexed nodeAddress,
        bool isAddition,
        uint256 proposalId
    );
    event VoteCast(
        address indexed voter,
        uint256 indexed proposalId,
        bool voteFor
    );
    event ProposalExecuted(uint256 indexed proposalId, bool success);

    constructor(address[] memory initialNodes) {
        for (uint256 i = 0; i < initialNodes.length; i++) {
            nodes.push(Node({addr: initialNodes[i], isActive: true}));
        }
    }

    modifier onlyActiveNode() {
        require(
            isActiveNode(msg.sender),
            "Only active nodes can call this function"
        );
        _;
    }

    function isActiveNode(address nodeAddress) public view returns (bool) {
        for (uint256 i = 0; i < nodes.length; i++) {
            if (nodes[i].addr == nodeAddress && nodes[i].isActive) {
                return true;
            }
        }
        return false;
    }

    function proposeNode(
        address nodeAddress,
        bool isAddition
    ) external onlyActiveNode {
        proposalCount++;
        Proposal storage newProposal = proposals[proposalCount];
        newProposal.proposer = msg.sender;
        newProposal.nodeAddress = nodeAddress;
        newProposal.isAddition = isAddition;
        newProposal.isActive = true;

        emit NodeProposed(msg.sender, nodeAddress, isAddition, proposalCount);
    }

    function voteOnProposal(
        uint256 proposalId,
        bool voteFor
    ) external onlyActiveNode {
        Proposal storage proposal = proposals[proposalId];

        require(proposal.isActive, "Proposal is not active");
        require(!proposal.voted[msg.sender], "Node has already voted");

        if (voteFor) {
            proposal.votesFor++;
        } else {
            proposal.votesAgainst++;
        }

        proposal.voted[msg.sender] = true;

        emit VoteCast(msg.sender, proposalId, voteFor);

        if (proposal.votesFor >= CONSENSUS_THRESHOLD) {
            executeProposal(proposalId);
        }
    }

    function executeProposal(uint256 proposalId) internal {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.isActive, "Proposal is not active");

        bool success;
        if (proposal.votesFor >= CONSENSUS_THRESHOLD) {
            if (proposal.isAddition) {
                nodes.push(Node({addr: proposal.nodeAddress, isActive: true}));
            } else {
                for (uint256 i = 0; i < nodes.length; i++) {
                    if (nodes[i].addr == proposal.nodeAddress) {
                        nodes[i].isActive = false;
                        break;
                    }
                }
            }
            success = true;
        }

        proposal.isActive = false;
        emit ProposalExecuted(proposalId, success);
    }

    // Additional functions to enhance the contract
    function getActiveNodes() external view returns (address[] memory) {
        uint256 activeCount = 0;
        for (uint256 i = 0; i < nodes.length; i++) {
            if (nodes[i].isActive) {
                activeCount++;
            }
        }

        address[] memory activeNodes = new address[](activeCount);
        uint256 index = 0;
        for (uint256 i = 0; i < nodes.length; i++) {
            if (nodes[i].isActive) {
                activeNodes[index] = nodes[i].addr;
                index++;
            }
        }
        return activeNodes;
    }

    function getProposalDetails(
        uint256 proposalId
    ) external view returns (address, address, bool, uint256, uint256, bool) {
        Proposal storage proposal = proposals[proposalId];
        return (
            proposal.proposer,
            proposal.nodeAddress,
            proposal.isAddition,
            proposal.votesFor,
            proposal.votesAgainst,
            proposal.isActive
        );
    }
}
