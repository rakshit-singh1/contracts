// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StakingContract {
    struct StakingInfo {
        uint256 stakedAmount;
        uint256 stakedTime;
        uint256 duration;
    }

    mapping(address => uint256) public lastStakeId;  // Keeps track of the last stake ID for each user
    mapping(address => mapping(uint256 => StakingInfo)) public stakes;  // Double mapping

    function stake(uint256 amount, uint256 duration) public {
        uint256 id = lastStakeId[msg.sender] + 1;  // Increment the stake ID
        lastStakeId[msg.sender] = id;  // Update the last stake ID for the user

        StakingInfo storage staking = stakes[msg.sender][id];
        staking.stakedAmount = amount;
        staking.stakedTime = block.timestamp;
        staking.duration = duration;
    }

    function getStakingInfo(uint256 id) public view returns (uint256, uint256, uint256) {
        StakingInfo storage staking = stakes[msg.sender][id];
        return (staking.stakedAmount, staking.stakedTime, staking.duration);
    }

    function getLastStakeId() public view returns (uint256) {
        return lastStakeId[msg.sender];
    }
}
