// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ComptrollerInterface.sol";
import "./CTokenInterfaces.sol";
// import "https://github.com/compound-finance/compound-protocol/blob/master/contracts/Comptroller.sol";
// import "https://github.com/compound-finance/compound-protocol/blob/master/contracts/CToken.sol";
contract MyDeFiProject {
    IERC20 dai;
    CTokenInterface cDai;
    IERC20 bat;
    CTokenInterface cBat;
    ComptrollerInterface comptroller;
    constructor (
    address _dai,
    address _cDai,
    address _bat,
    address _cBat,
    address _comptroller){
        dai = IERC20(_dai);
        cDai = CTokenInterface(_cDai);
        bat = IERC20(_bat);
        cBat = CTokenInterface(_cBat);
        comptroller = ComptrollerInterface(_comptroller);
    }
    function return_addresses() view public returns(address, address, address, address, address){
        return (address(dai), address(cDai), address(bat), address(cBat), address(comptroller));
    }
    function invest() external{
        dai.approve(address(cDai), 10000);
        cDai.mint(10000);
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
        bat.approve(address (cBat), 200);
        cBat.repayBorrow(100);
        //Optional

        uint balance = cDai.balanceOf(address(this));
        cDai.redeem(balance);
    }
    function transferEther(address payable receiver) public payable {
        require(msg.value > 0, "Please send some Ether");
        receiver.transfer(msg.value);
    }
}
// pragma solidity ^0.8.9;

// import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "./ComptrollerInterface.sol";
// import "./CTokenInterfaces.sol";

// contract MyDeFiProject is Ownable {
//     IERC20Metadata dai;
//     CTokenInterface cDai;
//     IERC20Metadata bat;
//     CTokenInterface cBat;
//     ComptrollerInterface comptroller;

//     constructor (
//         address _dai,
//         address _cDai,
//         address _bat,
//         address _cBat,
//         address _comptroller
//     ) {
//         dai = IERC20Metadata(_dai);
//         cDai = CTokenInterface(_cDai);
//         bat = IERC20Metadata(_bat);
//         cBat = CTokenInterface(_cBat);
//         comptroller = ComptrollerInterface(_comptroller);
//     }

//     function returnAddresses() view public returns (address, address, address, address, address) {
//         return (address(dai), address(cDai), address(bat), address(cBat), address(comptroller));
//     }

//     function invest() external onlyOwner returns (bool) {
//         // Approve cDai to spend DAI
//         bool approvalResult = dai.approve(address(cDai), type(uint256).max);
//         require(approvalResult, "DAI approval failed");
        
//         // Mint cDai
//         uint mintResult = cDai.mint(10000);
//         require(mintResult == 0, "cDai minting failed");

//         return true;
//     }

//     function cashout() external onlyOwner {
//         uint balance = cDai.balanceOf(address(this));
//         cDai.redeem(balance);
//     }

//     function getBalance() view public returns (uint) {
//         return cDai.balanceOf(address(this));
//     }

//     function borrow() external onlyOwner {
//         // Approve cDai to spend DAI
//         require(dai.approve(address(cDai), type(uint256).max), "DAI approval failed");

//         // Mint cDai
//         require(cDai.mint(10000) == 0, "cDai minting failed");

//         // Enter cDai market
//         address[] memory markets = new address[](1);
//         markets[0] = address(cDai);
//         comptroller.enterMarkets(markets);

//         // Borrow cBat
//         require(cBat.borrow(100) == 0, "cBat borrowing failed");
//     }

//     function payback() external onlyOwner {
//         // Approve cBat to spend BAT
//         require(bat.approve(address(cBat), type(uint256).max), "BAT approval failed");

//         // Repay cBat borrow
//         require(cBat.repayBorrow(1) == 0, "cBat repayment failed");

//         // Optional: Redeem cDai
//         uint balance = cDai.balanceOf(address(this));
//         if (balance > 0) {
//             require(cDai.redeem(balance) == 0, "cDai redemption failed");
//         }
//     }
// }
