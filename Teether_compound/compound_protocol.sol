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
    IERC20 teether;
    CTokenInterface cTeether;
    IERC20 dai;
    CTokenInterface cDai;
    ComptrollerInterface comptroller;
    constructor (
    address _teether,
    address _cTeether,
    address _dai,
    address _cDai,
    address _comptroller){
        teether = IERC20(_teether);
        cTeether = CTokenInterface(_cTeether);
        dai = IERC20(_dai);
        cDai = CTokenInterface(_cDai);
        comptroller = ComptrollerInterface(_comptroller);
    }
    function return_addresses() view public returns(address, address, address, address, address){
        return (address(teether), address(cTeether), address(dai), address(cDai), address(comptroller));
    }
    function invest() external{
        teether.approve(address(cTeether), 10000);
        cTeether.mint(10000);
    }

    function cashout() external{
        uint balance = cTeether.balanceOf(address(this));
        cTeether.redeem(balance);
    }

    function BALANCE() view public returns(uint){
        uint balance = cTeether.balanceOf(address(this));
        return balance;
    }

    function borrow() external{
        teether.approve(address (cTeether), 10000);
        cTeether.mint(10000);
        address[] memory markets = new address[](1);
        markets[0] = address(cTeether);
        comptroller.enterMarkets(markets);
        cDai.borrow(100);
    }

    function payback() external{
        dai.approve(address (cDai), 200);
        cDai.repayBorrow(100);
        //Optional

        uint balance = cTeether.balanceOf(address(this));
        cTeether.redeem(balance);
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
//     IERC20Metadata teether;
//     CTokenInterface cTeether;
//     IERC20Metadata dai;
//     CTokenInterface cDai;
//     ComptrollerInterface comptroller;

//     constructor (
//         address _teether,
//         address _cTeether,
//         address _dai,
//         address _cDai,
//         address _comptroller
//     ) {
//         teether = IERC20Metadata(_teether);
//         cTeether = CTokenInterface(_cTeether);
//         dai = IERC20Metadata(_dai);
//         cDai = CTokenInterface(_cDai);
//         comptroller = ComptrollerInterface(_comptroller);
//     }

//     function returnAddresses() view public returns (address, address, address, address, address) {
//         return (address(teether), address(cTeether), address(dai), address(cDai), address(comptroller));
//     }

//     function invest() external onlyOwner returns (bool) {
//         // Approve cTeether to spend teether
//         bool approvalResult = teether.approve(address(cTeether), type(uint256).max);
//         require(approvalResult, "teether approval failed");
        
//         // Mint cTeether
//         uint mintResult = cTeether.mint(10000);
//         require(mintResult == 0, "cTeether minting failed");

//         return true;
//     }

//     function cashout() external onlyOwner {
//         uint balance = cTeether.balanceOf(address(this));
//         cTeether.redeem(balance);
//     }

//     function getBalance() view public returns (uint) {
//         return cTeether.balanceOf(address(this));
//     }

//     function borrow() external onlyOwner {
//         // Approve cTeether to spend teether
//         require(teether.approve(address(cTeether), type(uint256).max), "teether approval failed");

//         // Mint cTeether
//         require(cTeether.mint(10000) == 0, "cTeether minting failed");

//         // Enter cTeether market
//         address[] memory markets = new address[](1);
//         markets[0] = address(cTeether);
//         comptroller.enterMarkets(markets);

//         // Borrow cDai
//         require(cDai.borrow(100) == 0, "cDai borrowing failed");
//     }

//     function payback() external onlyOwner {
//         // Approve cDai to spend dai
//         require(dai.approve(address(cDai), type(uint256).max), "dai approval failed");

//         // Repay cDai borrow
//         require(cDai.repayBorrow(1) == 0, "cDai repayment failed");

//         // Optional: Redeem cTeether
//         uint balance = cTeether.balanceOf(address(this));
//         if (balance > 0) {
//             require(cTeether.redeem(balance) == 0, "cTeether redemption failed");
//         }
//     }
// }
