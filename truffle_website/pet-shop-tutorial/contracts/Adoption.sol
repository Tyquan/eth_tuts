// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

contract Adoption {
    address[16] public adopters; // Array of 16 addresses waiting to be filled by Ethereum Addresses

    // Adopting a pet
    function adopt(uint petId) public returns (uint) {
        require(petId >= 0 && petId <= 15); // the petId must be between 0 and 15 because we only have 16 adopters slots available and 16 pets available

        adopters[petId] = msg.sender; // msg.sender is the address of the person or smart contract that is using this function

        return petId; // provided as a confirmation that the function ran successfully
    }

    // Retrieving the adopters (return the entire array of adopters addresses)
    // the memory keyword gives the data location of the variable
    function getAdopters() public view returns (address[16] memory) { // the view keyword means that the function will not modify the state of the contract
        // since adopters is already declared, we can simply return it
        return adopters;
    }
}