// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

/** 
@title Staking of an ERC 20 token
@author Rakshit Kumar Singh
@notice You can stake an ERC20 token for 2, 4, 6, 8 & 10 minutes and reieve reward of 1% per second
@dev You have to make an erc20 token say FUNGIBLE in this case then,
        convert the IERC20 instance to it. You can see the example in the constructor.
        FUNGIBLIE is the name of my contract in which erc20 token is made
*/

//// To run this staking contract first the owner have to mint or transfer some tokens to this contract

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";//importing IERC20 interface
import "@openzeppelin/contracts/utils/Counters.sol";

contract staking {
    using Counters for Counters.Counter;
    Counters.Counter private StakeIdCounter;

    IERC20 public token;
    address public owner;

    uint256 public interest = 1; // 1% interest

    struct StakingInfo {
        uint256 StakedAmount;
        uint256 StakedTime;
        uint256 duration;//in seconds
        bool expired;
    }
    mapping(uint256 => address) public stakingOwner;//Every ID has an owner
    mapping(uint256 => StakingInfo) public stakes;//Every staking has it's own ID
    //therefore 1 user can have multiple IDs of Staking Every time he stakes an amount the stake is assigned a unique ID
    mapping(address => uint256) public rewards;

    constructor(address _token) {
        // Initialize the staking contract with a specified ERC-20 token.
        token = IERC20(_token);
        owner = msg.sender;
    }

    // Function to stake tokens for a specified time period.
    // Users can stake tokens for 2, 4, 6, 8, or 10 minutes.
    // Tokens are transferred from the user to this contract.
    // Staking information is recorded (StakedAmount, StakedTime, duration, expired).
    // IMP: To stake a perticular amount it is required to take approval for the amount and that too from the token contract otherwise it will throw error
    function stake(uint256 _numTokens, uint256 time) external returns (uint256) {
        // Increment the stake ID counter. As it is being incremented in the start therefore, the counter starts from 1 so no records of id 0
        StakeIdCounter.increment();

        // Check for valid staking conditions and requirements.
        require(_numTokens > 0, "Must stake more than zero tokens");
        require(token.balanceOf(msg.sender) >= _numTokens, "Not Enough Balance Tokens To Stake");
        require(time == 2 || time == 4 || time == 6 || time == 8 || time == 10, "Time can Only be of 2,4,6,8,10 Minutes");

        // Record staking information for the user.
        uint256 current_time = block.timestamp;
        stakingOwner[StakeIdCounter.current()] = msg.sender;
        require(token.transferFrom(msg.sender, address(this), _numTokens), "Give approval from initial to stake");
        stakes[StakeIdCounter.current()].StakedAmount += _numTokens;
        stakes[StakeIdCounter.current()].StakedTime = current_time;//Recorded above
        stakes[StakeIdCounter.current()].duration = time * 60;// input is take in the form of minutes but will be stored in seconds for calculation simplicity
        stakes[StakeIdCounter.current()].expired = false;// This is a flag to ensure that the user has collected the amount back or not. Will be used further

        return StakeIdCounter.current();
    }

    // Function to retrieve stake IDs with staking information associated with a user.
    function IdsAndDetails(address ad) public view returns (uint256[] memory, StakingInfo[] memory) {
        // Count the number of stakes associated with the user.
        uint256 count = 0;
        for (uint256 i = 0; i <= StakeIdCounter.current(); i++) {
            if (stakingOwner[i] == ad) {
                count++;
            }
        }

        // Retrieve stake IDs and corresponding staking information.
        StakingInfo[] memory stakingInfos = new StakingInfo[](count);
        uint256[] memory userids = new uint256[](count);
        uint256 index = 0;
        for (uint256 i = 0; i <= StakeIdCounter.current(); i++) {
            if (stakingOwner[i] == ad) {
                stakingInfos[index] = stakes[i];
                userids[index] = i;
                index++;
            }
            if (index > count) {
                break;
            }
        }
        return (userids, stakingInfos);
    }

    // Function to retrieve only stake IDs associated with a user.
    function getIds(address ad) public view returns (uint256[] memory) {
        // Count the number of stakes associated with the user.
        uint256 count = 0;
        for (uint256 i = 0; i <= StakeIdCounter.current(); i++) {
            if (stakingOwner[i] == ad) {
                count++;
            }
        }

        // Retrieve stake IDs.
        uint256[] memory userids = new uint256[](count);
        uint256 index = 0;
        for (uint256 i = 0; i <= StakeIdCounter.current(); i++) {
            if (stakingOwner[i] == ad) {
                userids[index] = i;
                index++;
            }
        }
        return userids;
    }

    // Function to return staked time for a particular stake ID.
    function stakeTime(uint256 id) view public returns (uint256) {
        return stakes[id].StakedTime;
    }

    // Function to get the contract's token balance.
    function contractBalance() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    // Function to get the current timestamp. Used only for debugging purpose
    function CurrentTime() public view returns (uint256) {
        return block.timestamp;
    }

    // Internal function to get the minimum of two numbers. Used for internal calculation
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    // Internal function to update the reward for a stake. This function will update the reward for current id.
    //To see the current collected reward value could be checked from the map declared public
    function genrateReward(uint256 id) public {
        uint256 current_time = block.timestamp;
        uint256 stakingDuration = current_time - stakes[id].StakedTime;
        uint256 time = min(stakingDuration, stakes[id].duration);

        // Calculate and update the reward for the stake based on the staking duration.
        rewards[stakingOwner[id]] = rewards[stakingOwner[id]] + (stakes[id].StakedAmount * interest * time) / 100;
        stakes[id].StakedTime = current_time;
        stakes[id].duration = stakes[id].duration - time;
    }

    // Function to claim rewards for a user.
    // We have also updated the rewards for all users using previous function
    function claimReward(address ad) public {
        // Retrieve stake IDs associated with the user.
        uint256[] memory userids = getIds(ad);
        require(userids.length > 0, "You haven't staked any amount");

        // Iterate through the stake IDs and update rewards for each stake.
        for (uint256 i = 0; i < userids.length; i++) {
            if (!stakes[userids[i]].expired) {
                genrateReward(userids[i]);
            }
        }

        // Transfer the rewards to the user and reset the rewards for the user.
        require(rewards[ad] > 0, "No reward to claim");
        token.transfer(msg.sender, rewards[ad]);
        rewards[ad] = 0;
    }

    // Function to claim staked amounts for a user.
    function claimAmount(address ad) public {
        // Retrieve stake IDs associated with the user.
        uint256[] memory userids = getIds(ad);
        require(userids.length > 0, "No amount staked");

        // Iterate through the stake IDs and transfer staked amounts for each stake.
        for (uint256 i = 0; i < userids.length; i++) {
            if (!stakes[userids[i]].expired) {
                token.transfer(msg.sender, stakes[userids[i]].StakedAmount);
                stakes[userids[i]].StakedAmount = 0;
                stakes[userids[i]].expired = true;//after ecpired neither rewards could be claimed not amount  again
            }
        }
    }
}
