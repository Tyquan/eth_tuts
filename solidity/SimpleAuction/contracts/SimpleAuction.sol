// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

contract SimpleAuction {
    address payable public beneficiary;
    uint public auctionEndTime;

    // current state of the auction
    address public highestBidder;
    uint public highestBid;

    // allowed withdrawls of previous bids
    mapping(address => uint) pendingReturns;

    bool ended;

    // events that will be emitted on changes
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);
    
    // The auction has already ended
    error AuctionAlreadyEnded;
    // There is already a higher or equal bid
    error BidNotHighEnough(uint highestBid);
    // The auction has not ended yet
    error AuctionNotYetEnded;
    // The function auctionEnded has already been called
    error AuctionEndAlreadyCalled;
    
    constructor(uint biddingTime, address payable beneficiaryAddress)
    {
        beneficiary = beneficiaryAddress;
        auctionEndTime = block.timestamp + biddingTime;
    }

    /// Bid on the auction with the value sent
    /// together with this transaction.
    /// The value will only be refunded if the
    /// auction is not won.
    function bid() external payable {
        // Revert the call if the bidding period is over
        if (block.timestamp > auctionEndTime) {
            revert AuctionAlreadyEnded;
        }
        // If the bid is not higher, send the
        // money back (the revert statement
        // will revert all changes in this
        // function execution including
        // it having received the money)
        if (msg.value <= highestBid) {
            revert BidNotHighEnough(highestBid);
        }
        // Sending back the money by simply using
        // highestBidder.send(highestBid) is a security risk
        // because it could execute an untrusted contract.
        // It is always safer to let the recipients
        // withdraw their money themselves.
        if (highestBid != 0) {
            pendingReturns[highestBidder] += highestBid;
        }
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    // withdraw a bid that was overbid
    function withdraw() external returns (bool) {
        uint = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;
            if (!payable(msg.sender).send(amount)) {
                // reset the amount owing
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    // End the auction snd send the highest bid
    // to the beneficiary
    function auctionEnd() external {
        // It is a good guideline to structure functions that interact
        // with other contracts (i.e. they call functions or send Ether)
        // into three phases:
        // 1. checking conditions
        // 2. performing actions (potentially changing conditions)
        // 3. interacting with other contracts
        // If these phases are mixed up, the other contract could call
        // back into the current contract and modify the state or cause
        // effects (ether payout) to be performed multiple times.
        // If functions called internally include interaction with external
        // contracts, they also have to be considered interaction with
        // external contracts.

        // Conditions
        if (block.timestamp < auctionEndTime) {
            revert AuctionNotYetEnded;
        }
        if (ended) {
            revert AuctionEndAlreadyCalled;
        }

        // 2. Effects
        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        // 3. Iteraction
        beneficiary.transfer(highestBid);
    }
}