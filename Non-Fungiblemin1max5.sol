// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
contract MyToken is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;
    Counters.Counter private _tokenIdCounter;

    uint256 public tokenPrice = 0.1 ether;

    constructor() ERC721("Rupees", "Rs") {}
    function _baseURI() internal pure override returns (string memory) {
        return "https://gateway.pinata.cloud/ipfs/QmUgyQnR45VgF5DSXjU43th2EbRFYb4o2EFmYgnhfS883T/";
    }
    function safeMint(uint n) 
    public payable
    {
        require(msg.value >= tokenPrice*n, "Insufficient funds");
        require(balanceOf(msg.sender)+n>1 && balanceOf(msg.sender)+n<5, "You have to own alteast 1 token and You can own at max 5 tokens");
        for (uint256 i = 0; i < n; i++) {
            _tokenIdCounter.increment();
            uint256 tokenId = _tokenIdCounter.current();
            _safeMint(msg.sender, tokenId);
            string memory uri = string(abi.encodePacked(
            tokenId.toString(),
            ".jpeg"));
            _setTokenURI(tokenId, uri);
        }
        
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
    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) 
    internal 
    override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }
    
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}