// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMarketplace is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public tokenPrice = 0.1 ether;
    mapping(uint256 => uint256) public balances;

    constructor() ERC721("NFTMarketplace", "NFTM") {}

    function mintNFT() public payable {
        require(msg.value >= tokenPrice, "Insufficient funds");

        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _mint(msg.sender, newTokenId);
        balances[newTokenId] = msg.value;
    }

    function burnNFT(uint256 tokenId) public onlyOwner {
        _burn(tokenId);
        balances[tokenId] = 0;
    }

    function setTokenPrice(uint256 newPrice) public onlyOwner {
        tokenPrice = newPrice;
    }

    function withdrawBalance() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        payable(msg.sender).transfer(balance);
    }
}
