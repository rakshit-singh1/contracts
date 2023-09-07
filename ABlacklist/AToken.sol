// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "./ABlacklist.sol";

contract BToken is ERC20, ERC20Burnable, Ownable, blacklist {

    constructor() ERC20("MyToken", "MTK"){}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function transferFrom(address from,address to,uint256 tokenId) public override returns (bool){
        require(!isBlacklisted(msg.sender), "User Blacklisted");
        return super.transferFrom(from, to, tokenId);
    }
    
    function transfer(address to, uint256 value) public virtual override returns (bool) {
        require(!isBlacklisted(msg.sender), "User Blacklisted");
        return super.transfer(to, value);
        
    }

    function allowance(address owner, address spender) public view virtual override  returns (uint256) {
        require(!isBlacklisted(owner) && !isBlacklisted(spender) , "User Blacklisted");
        return super.allowance(owner,spender);
    }

    function transferOwnership(address newOwner) public virtual override onlyOwner {
        require(!isBlacklisted(newOwner), "User Blacklisted");
        super.transferOwnership(newOwner);
    }

    function burnUnsoldTokens() external onlyOwner {
        require(balanceOf(address(this)) > 0, "No unsold tokens");
        _burn(address(this), balanceOf(address(this))); // Burn unsold tokens
    }
    function transferBalanceToOwner() external onlyOwner {
        require(msg.sender == owner(), "Only the owner can call this function");
        payable(owner()).transfer(address(this).balance);
    }
}
//0xB932b4e70B045FD4D577Bb6EeAc639486354933b