// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
//import "@openzeppelin/contracts/utils/Strings.sol";
contract MyToken is ERC1155, Ownable, ERC1155Burnable, ERC1155Supply {
    constructor() ERC1155("link") {}
    uint256 tokenPrice=0.1 ether;
    uint256 maxSupply=60;
    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function settokenPrice(uint256 newPrice) public onlyOwner {
        tokenPrice=newPrice;
    }

    function mint(uint256 id, uint256 amount)
        public payable 
    {
        //require(msg.value==tokenPrice*amount,string(abi.encodePacked("Not correct price. Pay ",tokenPrice*amount)));
        require(msg.value==tokenPrice*amount,"Not correct price");
        require(totalSupply(id)+amount<=maxSupply,"Mint Exhausted");
        _mint(msg.sender, id, amount,"");
    }

    function mintBatch(uint256[] memory ids, uint256[] memory amounts)
        public payable
    {
        uint256 sum;
        for (uint256 i = 0; i < amounts.length; i++) {
            sum+=amounts[i];
        }
        require(msg.value==tokenPrice*sum,"Not correct price");
        _mintBatch(msg.sender, ids, amounts,"");
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}