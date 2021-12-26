// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Condos is ERC721, ERC721URIStorage {
    // Setup like a game Nft
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("CondosItem", "CND") {}

    function createNFT(address receiver, string memory tokenURI) public returns (uint256)
    {
        _tokenIds.increment();

        uint newItemId = _tokenIds.current();
        _mint(receiver, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

}