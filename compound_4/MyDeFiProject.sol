// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./CTokenInterface.sol";
import "./ComptrollerInterface.sol";
import "./PriceOracleInterface.sol";
//import "./interestRateModel.sol";
import "./LoanToken.sol";

contract MyDeFiProject is Loan{
    ComptrollerInterface public comptroller;
    // PriceOracleInterface public priceOracle;
    IERC20 public token;
    CTokenInterface public cToken;
    //InterestRateModel public JumpRateModel; 

    constructor(
        address _comptroller,
        // address _priceOracle,
        address _token,
        address _cToken
        //address _JumpRateModel
    ) {
        comptroller = ComptrollerInterface(_comptroller);
        // priceOracle = PriceOracleInterface(_priceOracle);
        cToken = CTokenInterface(_cToken);
        token = IERC20(_token);
        //JumpRateModel = InterestRateModel(_JumpRateModel);
    }
    mapping(uint256=>uint256) Liquidity;
    // mapping(uint256=>uint256) UnderlyingPrice;
    uint256 totalBorrows;
    
    function balance(address ad) public view returns(uint256){
        return token.balanceOf(ad);
    }

    function tokenAddress() public view returns(address){
        return cToken.underlying();
    }

    function tokenTransfer(address to, uint256 amount) public{
        token.transfer(to, amount);
    }

    function tokenTransferFrom(address from ,address to, uint256 amount) public{
        token.transferFrom(from,to, amount);
    }

    function allow(address spender, uint256 amount) public{
        token.approve(spender, amount);
    }

    function invest(uint underlyingAmount) public{
        // address underlyingAddress = address(token);
        // IERC20(underlyingAddress).approve(address(cToken), underlyingAmount);
        uint result = cToken.mint(underlyingAmount);
        require(result == 0, "mint() failed");
        // UnderlyingPrice[currId()-1] = priceOracle.getUnderlyingPrice(address(cToken));
        safeMint(msg.sender);
        Liquidity[currId()-1] = cToken.balanceOf(address(this));
    }
    // function interestRate(uint id) public view returns (uint){
    //     return JumpRateModel.getSupplyRate(Liquidity[id], totalBorrows, cToken.balanceOf(address(this))-totalBorrows, cToken.reserveFactorMantissa());
    // }
    function redeem(uint id) external {
        uint result = cToken.redeem(Liquidity[id]) /*+ interestRate(id)*/;
        //uint bal= token.balanceOf(address(msg.sender));
        require(result == 0, "redeem() failed");
        _burn(id);
        //bal=token.balanceOf(address(msg.sender))-bal;
        //bal=bal-Liquidity[id];
        //tokenTransfer(msg.sender,(bal/*+Liquidity[id]*/));
    }

    function _transfer(address from, address to, uint256 tokenId) internal override  {
        bool result = cToken.transferFrom(from,to,Liquidity[tokenId]);
        require(result, "transfer() failed");
        super._transfer(from,to,tokenId);
    }

    function enterMarket() external {
        address[] memory markets = new address[](1);
        markets[0] = address(cToken);
        uint[] memory results = comptroller.enterMarkets(markets);
        require(results[0] == 0, "enterMarket() failed");
    }

    function borrow(uint borrowAmount) external {
        //address underlyingAddress = cToken.underlying();
        totalBorrows+=borrowAmount;
        uint result = cToken.borrow(borrowAmount);
        require(result == 0, "borrow() failed");
    }

    function repayBorrow(uint underlyingAmount) external {
        totalBorrows-=underlyingAmount;
        address underlyingAddress = cToken.underlying();
        IERC20(underlyingAddress).approve(address(cToken), underlyingAmount);
        uint result = cToken.repayBorrow(underlyingAmount);
        require(result == 0, "repayBorrow() failed");
    }

    function transferEther(address payable receiver) public payable {
        require(msg.value > 0, "Please send some Ether");
        receiver.transfer(msg.value);
    }
    // function getMaxBorrow() external view returns(uint) {
    //   (uint result, uint liquidity, uint shortfall) = comptroller.getAccountLiquidity(address(this));
    //   require(result == 0, "getAccountLiquidity() failed");
    //   require(shortfall == 0, "account in loss");
    //   require(liquidity > 0, "account does not have collateral");
    //   uint underlyingPrice = priceOracle.getUnderlyingPrice(address(cToken));
    //   return liquidity / underlyingPrice;
    // }
}
//mainet
//0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B
//0xdAC17F958D2ee523a2206206994597C13D831ec7
//0xf650C3d88D12dB855b8bf7D11Be6C55A4e07dCC9

//goreli
//0x05Df6C772A563FfB37fD3E04C1A279Fb30228621
//0x79C950C7446B234a6Ad53B908fBF342b01c4d446
//0x5A74332C881Ea4844CcbD8458e0B6a9B04ddb716
//0xd731C20d311839e829963831C6299B6dD8FA691a

//contract address:0x1249cB13d9b9bf678b1d5a5cA9d9a9EfAc968B0E
