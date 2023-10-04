// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./CTokenInterface.sol";
import "./ComptrollerInterface.sol";
import "./PriceOracleInterface.sol";
import "./LoanToken.sol";

contract MyDeFiProject is Loan{
    ComptrollerInterface public comptroller;
    // PriceOracleInterface public priceOracle;
    IERC20 public token;
    CTokenInterface public cToken;

    constructor(
        address _comptroller,
        // address _priceOracle,
        address _token,
        address _cToken
    ) {
        comptroller = ComptrollerInterface(_comptroller);
        // priceOracle = PriceOracleInterface(_priceOracle);
        cToken = CTokenInterface(_cToken);
        token = IERC20(_token);
    }
    mapping(uint256=>uint256) Liquidity;
    mapping(uint256=>uint256) UnderlyingPrice;
    
    function balance(address ad) public view returns(uint256){
        return token.balanceOf(ad);
    }

    function tokenAddress() public view returns(address){
        return cToken.underlying();
    }

    function tokenTransfer(address to, uint256 tokenId) public{
        token.transfer(to, tokenId);
    }

    function tokenTransferFrom(address from ,address to, uint256 tokenId) public{
        token.transferFrom(from,to, tokenId);
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
        Liquidity[currId()-1] = underlyingAmount;
        safeMint(msg.sender);
    }

    function redeem(uint id) external {
        uint result = cToken.redeem(Liquidity[id]);
        require(result == 0, "redeem() failed");
        _burn(id);
    }

    // function interestGetableNow(uint256 id) public view returns(uint256){
    //     uint256 diff = UnderlyingPrice[id] - priceOracle.getUnderlyingPrice(address(cToken));
    //     return (diff * 100)/UnderlyingPrice[id];
    // }

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
        uint result = cToken.borrow(borrowAmount);
        require(result == 0, "borrow() failed");
    }

    function repayBorrow(uint underlyingAmount) external {
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
