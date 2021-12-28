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

    
}