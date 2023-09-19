// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; 
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract E11554 is ERC1155, Ownable, ERC1155Burnable, ERC1155Supply {
    using Strings for uint256;
    constructor() ERC1155("ipfs://Qmac89sZTSGvKkyYa2vrxdRakPREaGFJSNJRRWetzTLQTM/"){
    }
    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }
    // Override the URI function to provide token-specific metadata.
    function uri(uint256 id) public view virtual override returns (string memory)  {
        return
        string(abi.encodePacked(
        super.uri(id),
        Strings.toString(id),
        ".json"));
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
        onlyOwner
    {
        _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
    function contractURI() public pure returns(string memory){
        return "ipfs://QmVaayEQFKjBttmZXiV6BCrg585LP5THpGhEB1nEbi8SA4";
    }
}
//0x09cf3416273a1c7ee57c094fcd28c5df6cbe7c4c