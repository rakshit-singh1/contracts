// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract StakingContract is Ownable {
    using SafeMath for uint256;

    IERC20 public stakingToken;
    IERC20 public rewardsToken;

    uint256 public totalStaked;
    uint256 public rewardsPerBlock;
    uint256 public lastUpdateBlock;

    mapping(address => uint256) public stakedBalances;
    mapping(address => uint256) public rewardsEarned;

    constructor(address _stakingToken, address _rewardsToken, uint256 _rewardsPerBlock) {
        stakingToken = IERC20(_stakingToken);
        rewardsToken = IERC20(_rewardsToken);
        rewardsPerBlock = _rewardsPerBlock;
        lastUpdateBlock = block.number;
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        stakingToken.transferFrom(msg.sender, address(this), amount);
        updateRewards(msg.sender);
        stakedBalances[msg.sender] = stakedBalances[msg.sender].add(amount);
        totalStaked = totalStaked.add(amount);
    }

    function unstake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(stakedBalances[msg.sender] >= amount, "Insufficient staked balance");
        updateRewards(msg.sender);
        stakedBalances[msg.sender] = stakedBalances[msg.sender].sub(amount);
        totalStaked = totalStaked.sub(amount);
        stakingToken.transfer(msg.sender, amount);
    }

    function updateRewards(address account) internal {
        uint256 currentBlock = block.number;
        uint256 blocksSinceLastUpdate = currentBlock.sub(lastUpdateBlock);
        uint256 rewards = stakedBalances[account].mul(rewardsPerBlock).mul(blocksSinceLastUpdate);
        rewardsEarned[account] = rewardsEarned[account].add(rewards);
        lastUpdateBlock = currentBlock;
    }

    function claimRewards() external {
        updateRewards(msg.sender);
        uint256 rewards = rewardsEarned[msg.sender];
        rewardsEarned[msg.sender] = 0;
        rewardsToken.transfer(msg.sender, rewards);
    }

    function setRewardsPerBlock(uint256 _rewardsPerBlock) external onlyOwner {
        rewardsPerBlock = _rewardsPerBlock;
    }

    function withdrawUnclaimedRewards() external onlyOwner {
        uint256 unclaimedRewards = rewardsToken.balanceOf(address(this));
        rewardsToken.transfer(owner(), unclaimedRewards);
    }
}
