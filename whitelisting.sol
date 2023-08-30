// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.5.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.5.0/utils/Counters.sol";
import "@openzeppelin/contracts@4.5.0/utils/cryptography/MerkleProof.sol";

contract MyToken is ERC721, Ownable {
    using Counters for Counters.Counter;
    bytes32 public root;
    uint non_member_price=0.1 ether;
    Counters.Counter private _tokenIdCounter;

    constructor(bytes32 _root) ERC721("MyToken", "MTK") {
        root = _root;
    }

    function safeMint(address to, bytes32[] memory proof) public payable{
        require(isValid(proof, keccak256(abi.encodePacked(msg.sender))), "Not a part of Allowlist. Therefore payment of 0.1 ether per mint required");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }
    function paidMint(address to) public payable{
        require(msg.value >= non_member_price, "Please pay the required price");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function isValid(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
        return MerkleProof.verify(proof, root, leaf);
    }
    function transferBalanceToOwner() external {
        require(msg.sender == owner(), "Only the owner can call this function");
        payable(owner()).transfer(address(this).balance);
    }
}
//0x14b75f13df712a3bdb33c584b9b334c580f0ca21633d5a4b0a14407b54843c7d