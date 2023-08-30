// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, ERC20Burnable, Ownable {
    uint256 public tokenPrice;

    constructor() ERC20("MyToken", "MTK") {
        tokenPrice = 0.1 ether;
    }

    function setTokenPrice(uint256 _newPrice) external onlyOwner {
        tokenPrice = _newPrice;
    }  

    function buyTokens(uint256 _numTokens) external payable {
        uint256 totalCost = _numTokens * tokenPrice;
        require(msg.value >= totalCost, "Insufficient ethers sent");
        _mint(msg.sender, _numTokens);
    }

    function sellTokens(uint256 _numTokens) external {
        require(balanceOf(msg.sender) >= _numTokens, "Insufficient tokens");
        require(balanceOf(owner()) >= _numTokens, "Not enough tokens in owner's balance");

        uint256 refundAmount = _numTokens * tokenPrice;
        require(address(this).balance >= refundAmount, "Contract does not have enough ethers to refund");

        _burn(msg.sender, _numTokens); // Burn tokens
        payable(msg.sender).transfer(refundAmount);
    }

    function burnUnsoldTokens() external onlyOwner {
        uint256 unsoldTokens = balanceOf(address(this));
        require(unsoldTokens > 0, "No unsold tokens");
        _burn(address(this), unsoldTokens); // Burn unsold tokens
    }
}
