// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "./Blacklist.sol";

contract MyToken is ERC20, ERC20Burnable, Ownable, blacklist {
    event tokens_to_buy(uint a);

    uint256 public tokenPrice;

    constructor() ERC20("MyToken", "MTK") {
        tokenPrice = 10 wei;
    }

    function setTokenPrice(uint256 _newPrice) external onlyOwner {
        tokenPrice = _newPrice;
    }
    function Mint(uint256 _numTokens) external payable onlyOwner  {
        _mint(msg.sender, _numTokens);
    }  

    function buyTokens(uint256 _numTokens) external payable {
        uint256 totalCost = _numTokens * tokenPrice;
        require(msg.value >= totalCost, "Insufficient ethers sent");
        require(isBlacklisted(msg.sender)!=true, "User Blacklisted");
        emit tokens_to_buy(balanceOf(owner()));
        require(balanceOf(owner()) >= _numTokens, "Not enough tokens in owner's balance");
        _transfer(owner(),msg.sender,_numTokens);
    }

    function burnUnsoldTokens() external onlyOwner {
        require(balanceOf(address(this)) > 0, "No unsold tokens");
        _burn(address(this), balanceOf(address(this))); // Burn unsold tokens
    }
    function transferBalanceToOwner() external {
        require(msg.sender == owner(), "Only the owner can call this function");
        payable(owner()).transfer(address(this).balance);
    }
}