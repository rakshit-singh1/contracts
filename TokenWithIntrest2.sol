// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyToken is ERC20, ERC20Burnable, Ownable {
    uint256 public tokenPrice;
    mapping(uint256 => uint256) public buy_time;
    mapping(uint256 => address) public id;
    uint256 public interest= 10;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC20("MyToken", "MTK") {
        tokenPrice = 0.1 ether;
    }

    function setTokenPrice(uint256 _newPrice) external onlyOwner {
        tokenPrice = _newPrice;
    }

    function buyTokens(uint256 _numTokens) public payable {
        require(msg.value >= _numTokens * tokenPrice, "Insufficient ethers sent");
        _mint(msg.sender, _numTokens);
        uint256 a = block.timestamp;
        for (uint256 i = 1; i <= _numTokens; i++) {
            _tokenIdCounter.increment();
            buy_time[_tokenIdCounter.current()] = a;
            id[_tokenIdCounter.current()] = msg.sender;
        }
    }

    function getReward() public{
        uint256 totalInterest = 0;
        for (uint256 i = 1; i <= _tokenIdCounter.current(); i++) {
            if (id[i] == msg.sender) {
                totalInterest += (block.timestamp - buy_time[i]) / (1 days) * interest/100;
                buy_time[i] = block.timestamp;
            }
        }
        uint256 refundAmount = totalInterest * tokenPrice;
        require(refundAmount > 0, "No refund amount");
        require(balanceOf(address(this)) >refundAmount, "Not enough balance to refund. Try again later");
        payable(msg.sender).transfer(refundAmount);
    }

    function sellTokens(uint256 _numTokens)public {
        require(balanceOf(msg.sender) >= _numTokens, "Insufficient tokens");
        getReward();
        uint256 refundAmount = _numTokens  * tokenPrice;
        require(balanceOf(address(this)) >refundAmount, "Not enough balance to refund. Try again later");
        payable(msg.sender).transfer(refundAmount);
    }

    function burnUnsoldTokens() internal onlyOwner {
        uint256 unsoldTokens = balanceOf(address(this));
        require(unsoldTokens > 0, "No unsold tokens");
        _burn(address(this), unsoldTokens); // Burn unsold tokens
    }
    function transferBalanceToOwner() external {
        require(msg.sender == owner, "Only the owner can call this function");
        payable(owner).transfer(address(this).balance);
    }
}
