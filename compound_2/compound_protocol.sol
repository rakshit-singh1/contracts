// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ComptrollerInterface.sol";
import "./CTokenInterfaces.sol";
contract MyDeFiProject {
    IERC20 dai;
    CErc20Interface cDai;
    IERC20 bat;
    CErc20Interface cBat;
    ComptrollerInterface comptroller;
    constructor (
    address _dai,
    address _cDai,
    address _bat,
    address _cBat,
    address _comptroller){
        dai = IERC20(_dai);
        cDai = CErc20Interface(_cDai);
        bat = IERC20(_bat);
        cBat = CErc20Interface(_cBat);
        comptroller = ComptrollerInterface(_comptroller);
    }
    function return_addresses() view public returns(address, address, address, address, address){
        return (address(dai), address(cDai), address(bat), address(cBat), address(comptroller));
    }
    function invest() external returns(bool){
        bool a = dai.approve(address(cDai), 10000);
        cDai.mint(10000);
        return a;
    }

    function cashout() external{
        uint balance = cDai.balanceOf(address(this));
        cDai.redeem(balance);
    }

    function BALANCE() view public returns(uint){
        uint balance = cDai.balanceOf(address(this));
        return balance;
    }

    function borrow() external{
        dai.approve(address (cDai), 10000);
        cDai.mint(10000);
        address[] memory markets = new address[](1);
        markets[0] = address(cDai);
        comptroller.enterMarkets(markets);
        cBat.borrow(100);
    }

    function payback() external{
        bat.approve(address (cBat), 2);
        cBat.repayBorrow(1);
        //Optional

        uint balance = cDai.balanceOf(address(this));
        cDai.redeem(balance);
    }
    function transferEther(address payable receiver) public payable {
        require(msg.value > 0, "Please send some Ether");
        receiver.transfer(msg.value);
    }
}