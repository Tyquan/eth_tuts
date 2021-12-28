// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

/// @title Voting with delegation.
contract Ballot {
    // represents a single voter
    struct Voter {
        uint weight; // accumulated by delegeation
        bool voted; // if true, person already voted
        address delegate;  // person delegated to
        uint vote; // index of the voted proposal
    }

    // represents a single proposal
    struct Proposal {
        bytes32 name; // short name (up to 32 bytes)
        uint voteCount; // number of accumulated votes
    }

    address public chairPerson;

    // stores a Voter struct for each possible address
    mapping(address => Voter) public voters;

    // array of Proposal structs
    Proposal[] public proposals;

    // create a new ballot to choose one of the 'proposalNames'
    constructor(bytes32[] memory proposalNames) public {
        chairPerson = msg.sender;
        voters[chairPerson].weight = 1;
        // For each of the provided proposal names,
        // create a new proposal object and add it
        // to the end of the array.
        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    // right to vote
    function giveRightToVote(address voter) external {
        require(msg.sender == chairPerson, "Only the chairPerson can give right to vote");
        require(!voters[voter].voted, "The voter already voted");
        require(voters[voter].weight == 0, "Voter must have no weight");
        voters[voter].weight = 1;
    }

    // Delegate your vote to the voter
    function delegate(address to) external {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "You already voted");

        require(to != msg.sender, "Self-delegation is disallowed");
        // Forward the delegation as long as
        // `to` also delegated.
        // In general, such loops are very dangerous,
        // because if they run too long, they might
        // need more gas than is available in a block.
        // In this case, the delegation will not be executed,
        // but in other situations, such loops might
        // cause a contract to get "stuck" completely.
        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

            // We found a loop in the delegation, not allowed.
            require(to != msg.sender, "Found loop in delegation. Not allowed.");
        }

        sender.voted = true;
        sender.delegate = to;
        Voter storage _delegate = voters[to];
        if (_delegate.voted) {
            // If the delegate already voted,
            // directly add to the number of votes
            proposals[_delegate.vote].voteCount += sender.weight;
        } else {
            _delegate.weight += sender.weight;
        }
    }

    // Give a vote
    function vote(uint proposal) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;
        // If `proposal` is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        proposals[proposal].voteCount += sender.weight;
    }

    /// @dev Computes the winning proposal taking all
    /// previous votes into account.
    function winningProposal() public view returns (uint _winningProposal) {
        uint winningVoteCount = 0;
        for (uint j = 0; j < proposals.length; j++) {
            if (proposals[j].voteCount > winningVoteCount) {
                winningVoteCount = proposals[j].voteCount;
                _winningProposal = j;
            }
        }
    }
}