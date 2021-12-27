// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

contract Coin {
    // accessible from other contracts
    address public minter;
    mapping(address => uint) public balances;

    event Sent(address from, address to, uint amount);

    constructor() public {
        minter = msg.sender;
    }

    // sends newly created coins to a specific address
    // can only be called by the contracts creatoer
    function mint(address receiver, uint amount) public {
        require(msg.sender == minter, "Mint can only be called by this contracts creator");
        balances[receiver] += amount;
    }

    // why this contract would fail
    error InsufficientBalance(uint requested, uint available);

    // allow addresses to send coins to one another
    function send(address receiver, uint amount) public {
        if (amount > balances[msg.sender]) {
            revert InsufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });
        }

        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}