// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeFy{
    struct Users{
        bool registered;
        uint256 PreviousLoanTime;
        uint256 InterestPayable;
        uint256 balances;
    }
    mapping(address=>Users) Info;

    
    function register() external{
        Info[msg.sender].registered=true;
    }
    function deposit() public payable {
        require(Info[msg.sender].registered==true,"User Not registered");
        require(msg.value > 0, "Deposit amount must be greater than 0");
        Info[msg.sender].balances+= msg.value;
    }
    function loan_approval(uint256 amount) internal view returns(bool){
        require(Info[msg.sender].registered==true,"User Not registered");
        require(Info[msg.sender].PreviousLoanTime-block.timestamp<=6 minutes,"User Not registered");
        return amount<=Info[msg.sender].balances;
    }
    function submit(uint256 amount) external payable{
        require(loan_approval(amount),"Loan not approved");
    }
}

