// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MoolahCoin is ERC20 {
    constructor() ERC20("Moolah Coin", "MC") {
        _mint(msg.sender, 100000 * (10 ** uint256(decimals())));
    }
}