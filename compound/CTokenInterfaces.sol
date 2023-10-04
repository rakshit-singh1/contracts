// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./ComptrollerInterface.sol";

abstract contract CTokenInterface {
    function transfer(address dst, uint amount) public virtual returns (bool);
    function transferFrom(address src, address dst, uint amount) public virtual returns (bool);
    function approve(address spender, uint amount) public virtual returns (bool);
    function allowance(address owner, address spender) public virtual view returns (uint);
    function balanceOf(address owner) public virtual view returns (uint);
    function balanceOfUnderlying(address owner) public virtual returns (uint);
    function getAccountSnapshot(address account) public virtual view returns (uint, uint, uint, uint);
    function borrowRatePerBlock() public virtual view returns (uint);
    function supplyRatePerBlock() public virtual view returns (uint);
    function totalBorrowsCurrent() public virtual returns (uint);
    function borrowBalanceCurrent(address account) public virtual returns (uint);
    function borrowBalanceStored(address account) public virtual view returns (uint);
    function exchangeRateCurrent() public virtual returns (uint);
    function exchangeRateStored() public virtual view returns (uint);
    function getCash() public virtual view returns (uint);
    function accrueInterest() public virtual returns (uint);
    function seize(address liquidator, address borrower, uint seizeTokens) public virtual returns (uint);

    function mint(uint mintAmount) public virtual returns (uint);
    function redeem(uint redeemTokens) public virtual returns (uint);
    function redeemUnderlying(uint redeemAmount) public virtual returns (uint);
    function borrow(uint borrowAmount) public virtual returns (uint);
    function repayBorrow(uint repayAmount) public virtual returns (uint);
    function repayBorrowBehalf(address borrower, uint repayAmount) public virtual returns (uint);
    function liquidateBorrow(address borrower, uint repayAmount, CTokenInterface cTokenCollateral) public virtual returns (uint);
    //function sweepToken(EIP20NonStandardInterface token) public virtual;
}
