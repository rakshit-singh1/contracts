// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract MyToken is ERC721A, Ownable {
   
    uint256 public tokenPrice = 1 ether;

    constructor() ERC721A("Rupees", "Rs") {}
    function _baseURI() internal pure override returns (string memory) {
        return "https://gateway.pinata.cloud/ipfs/QmUgyQnR45VgF5DSXjU43th2EbRFYb4o2EFmYgnhfS883T/";
    }
    function Mint(uint n) 
    public payable
    {
        require(msg.value >= (tokenPrice*n),"Not Enough tokens available");
        require(balanceOf(msg.sender)+n>1 && balanceOf(msg.sender)+n<5, "You have to own alteast 1 token and You can own at max 5 tokens");
        _safeMint(msg.sender,n);
        payable(msg.sender).transfer(msg.value-tokenPrice*n);
    }
    function setTokenPrice(uint256 newPrice) 
    public onlyOwner
    {
        tokenPrice = newPrice;
    }
    function withdrawBalance() 
    public onlyOwner
    {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        payable(msg.sender).transfer(balance);
    }
    function burnNFT(uint256 tokenId) public onlyOwner {
        _burn(tokenId);
    }
    function transferBalanceToOwner() external {
        require(msg.sender == owner, "Only the owner can call this function");
        payable(owner).transfer(address(this).balance);
    }
}
   