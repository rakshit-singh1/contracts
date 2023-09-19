// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FUNGIBLE is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("TOKEN", "TOK") {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
    function transferBalanceToOwner() external {
        require(msg.sender == owner(), "Only the owner can call this function");
        payable(owner()).transfer(address(this).balance);
    }
}
//0x2e777c5b0052d933500ead5bd34ba995deb6bff2