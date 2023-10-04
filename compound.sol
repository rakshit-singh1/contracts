// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Compound-like interface for USDT
interface CTokenInterface {
    function mint(uint mintAmount) external returns (uint);
    function redeem(uint redeemTokens) external returns (uint);
    function borrow(uint borrowAmount) external returns (uint);
    function repayBorrow(uint repayAmount) external returns (uint);
    function balanceOf(address account) external view returns (uint);
}

contract CompoundUSDT {
    CTokenInterface public cToken;
    IERC20 public usdt;

    constructor(address _cTokenAddress, address _usdtAddress) {
        cToken = CTokenInterface(_cTokenAddress);
        usdt = IERC20(_usdtAddress);
    }

    function supply(uint underlyingAmount) external {
        require(usdt.approve(address(cToken), underlyingAmount), "Approval failed");
        //require(usdt.transferFrom(msg.sender, address(this), underlyingAmount), "USDT transfer failed");
        uint result = cToken.mint(underlyingAmount);
        require(result == 0, "Mint failed");
    }

    function redeem(uint cTokenAmount) external {
        uint result = cToken.redeem(cTokenAmount);
        require(result == 0, "Redeem failed");
        require(usdt.transfer(msg.sender, cTokenAmount), "USDT transfer failed");
    }

    function borrow(uint borrowAmount) external {
        uint result = cToken.borrow(borrowAmount);
        require(result == 0, "Borrow failed");
        require(usdt.transfer(msg.sender, borrowAmount), "USDT transfer failed");
    }

    function repayBorrow(uint repayAmount) external {
        require(usdt.transferFrom(msg.sender, address(this), repayAmount), "USDT transfer failed");
        require(usdt.approve(address(cToken), repayAmount), "Approval failed");
        uint result = cToken.repayBorrow(repayAmount);
        require(result == 0, "Repay failed");
    }

    function getCTokenBalance() external view returns (uint) {
        return cToken.balanceOf(address(this));
    }
}
