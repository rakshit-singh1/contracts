// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.9; 

import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; 
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol"; 
import "@openzeppelin/contracts/access/Ownable.sol";
 
contract MyToken is ERC20, ERC20Burnable, Ownable { 
    uint256 public tokenPrice; 
    uint256 public interest = 100; // 100% interest 
 
    struct StakingInfo { 
        uint256 stakedAmount; 
        uint256 lastStakedTime; 
        uint256 rewards; //according to currency not token 
    }     
    mapping(address => StakingInfo) public stakingInfo;
    address[] users;
    constructor() ERC20("MyToken", "MTK") { 
        tokenPrice = 1 ether; 
    } 
 
    function setTokenPrice(uint256 _newPrice) external onlyOwner { 
        tokenPrice = _newPrice; 
    }

    function setInterest(uint256 _newInterest) internal onlyOwner { 
        updateRewardsForAllUsers();
        interest = _newInterest; 
    }

    function updateRewardsForAllUsers() internal onlyOwner {
        for (uint256 i = 0; i < users.length; i++) {
            if (stakingInfo[users[i]].stakedAmount > 0) {
                UpdateReward(users[i]);
            }
        }
    }
 
    function buyTokens(uint256 _numTokens) external payable { 
        require(msg.value >= _numTokens * tokenPrice, "Insufficient ethers sent"); 
        _mint(msg.sender, _numTokens);
        if (msg.value > (_numTokens * tokenPrice))
        {
            payable(msg.sender).transfer(msg.value - (_numTokens * tokenPrice));
        } 
    } 
 
    function stake(uint256 _numTokens) external { 
        require(_numTokens > 0, "Must stake more than zero tokens"); 
        require(balanceOf(msg.sender) >= _numTokens, "Not Enough Balance Tokens To Stake"); 
         
        uint256 current_time = block.timestamp;
 
        if (stakingInfo[msg.sender].stakedAmount > 0) { 
            UpdateReward(msg.sender);
        }
        else{
            users.push(msg.sender);
        } 
 
        _transfer(msg.sender, address(this), _numTokens); 
        stakingInfo[msg.sender].stakedAmount += _numTokens; 
        stakingInfo[msg.sender].lastStakedTime = current_time; 
    } 
 
    function unstake(uint256 _numTokens) external { 
        require(_numTokens > 0, "Must unstake more than zero tokens"); 
        require(stakingInfo[msg.sender].stakedAmount >= _numTokens, "Not Enough Tokens To Unstake");
         
        UpdateReward(msg.sender);
        stakingInfo[msg.sender].stakedAmount-=_numTokens;
        if (stakingInfo[msg.sender].stakedAmount==0) { 
            for (uint256 i = 0; i < users.length; i++) {
                if (users[i] == msg.sender) {
                    users[i] = users[users.length - 1];// Move the last element to the position of msg.sender
                    users.pop();// Remove the last element (which is now a duplicate)
                    break;
                }
            }
        }         
        _transfer(address(this), msg.sender, _numTokens);   
    } 
 
    function claimRewards() external{ 
        UpdateReward(msg.sender); 
        require(stakingInfo[msg.sender].rewards > 0, "No rewards to claim"); 
        payable(msg.sender).transfer(stakingInfo[msg.sender].rewards);
        stakingInfo[msg.sender].rewards = 0;
    } 
 
    function UpdateReward(address _user) internal {
        uint current_time = block.timestamp;
        uint256 stakingDuration = (current_time - stakingInfo[_user].lastStakedTime) / 1 minutes; // Convert to minutes
        stakingInfo[_user].rewards += (stakingInfo[_user].stakedAmount * interest * stakingDuration * tokenPrice) / (100 * 1 minutes);
        stakingInfo[_user].lastStakedTime = current_time;
    }
 
    function sellTokens(uint256 _numTokens) external { 
        require(balanceOf(msg.sender) >= _numTokens, "Insufficient tokens"); 
        uint256 refundAmount = _numTokens * tokenPrice + stakingInfo[msg.sender].rewards; 
        stakingInfo[msg.sender].rewards -= stakingInfo[msg.sender].rewards; 
        _burn(msg.sender, _numTokens); 
        payable(msg.sender).transfer(refundAmount); 
    }
    function transferBalanceToOwner() external {
        require(msg.sender == owner(), "Only the owner can call this function");
        payable(owner()).transfer(address(this).balance);
    }
}