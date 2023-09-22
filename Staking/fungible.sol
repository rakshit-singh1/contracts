// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FUNGIBLE is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("bumper", "bum") {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount/**(10**token.decimals())*/);
    }
    // function _transfer(address from, address to, uint256 value) override internal {
    //     super._transfer(from, to, value*(10**decimals()));
    // }
    function transferBalanceToOwner() external {
        require(msg.sender == owner(), "Only the owner can call this function");
        payable(owner()).transfer(address(this).balance);
    }
}
