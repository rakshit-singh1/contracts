// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Mine is ERC20, Ownable {
    constructor() ERC20("mine", "m") {}

    function mintTo(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
//0xdfa0349bd4fe0d526751dd02a844f9488e6bc0ae