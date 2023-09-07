// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract E721A is ERC721A, Ownable {

    constructor() ERC721A("e721a", "721a") {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://Qmac89sZTSGvKkyYa2vrxdRakPREaGFJSNJRRWetzTLQTM/";
    }

    function Mint(uint n) public onlyOwner 
    {
        _safeMint(msg.sender,n);
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (!_exists(tokenId)) _revert(URIQueryForNonexistentToken.selector);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length != 0 ? string(abi.encodePacked(_baseURI(), _toString(tokenId),".json")) : '';
    }
}
//0x246bee0125939171f41e004cfdb586aebc87882c