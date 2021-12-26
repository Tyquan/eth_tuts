// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MoolahCoin is ERC20 {
    constructor() ERC20("Moolah Coin", "MC") {
        _mint(msg.sender, 100000 * (10 ** uint256(decimals())));
    }
}