// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

// Simple Getter and Setter Contract to store and retrieve a value
contract SimpleStorage {
    // default uint === uint256 , single slot in the blockchain database
    uint storedData;

    // set the value of the storedData variable
    function set(uint x) public {
        storedData = x;
    }

    // retreive the value of the storeddata variable
    function get() public view returns (uint) {
        return storedData;
    }
}