// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Condos is ERC721 {

    uint256 public _tokenId;

    mapping(address => uint256) public MDTrack;

    constructor() ERC721("CondosItem", "CND") {
        _tokenId = 0;
    }

    function createNFT(address receiver) external returns (uint256) {
        _tokenId++;
        _mint(receiver, _tokenId);
        return _tokenId;
    }

    function transferNFT(address sender, address receiver, uint256 tokenId) external payable returns (uint256) {
        transferFrom(sender, receiver, tokenId);
        delete MDTrack[sender];
        MDTrack[receiver] = _tokenId;
        return _tokenId;
    }

}