// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./FungibleToken.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract DeFy is MyToken{
    using Counters for Counters.Counter;

    Counters.Counter private ID;

    uint256 InterestPercentage=200;

    struct Loan{
        uint256 id;
        uint256 LoanTime;
        uint256 LoanAmmount;
        uint256 InterestPayable;
    }

    struct User{
        bool registered;
        Loan[] loans;
        uint256 balances;
        uint256 PreviousLoanTime;
    }

    mapping(address=>User) Info;

    function register() external{
        Info[msg.sender].registered=true;
    }
    function calculate_Interest(address user_address) internal{
        uint256 curr_time=block.timestamp;
        for(uint256 i=0; i<Info[user_address].loans.length;i++){
            //Info[user_address].loans[i].InterestPayable+=(Info[user_address].loans[i].LoanAmmount*InterestPercentage*((Info[user_address].loans[i].LoanTime - curr_time)%6 minutes));
        }
    }
    function calculate_curr_loan_amt(address user_address) internal returns(uint256){
        uint256 total_loan;
        for(uint256 i=0; i<Info[user_address].loans.length;i++){
            total_loan+=(Info[user_address].loans[i].LoanAmmount+Info[user_address].loans[i].InterestPayable);
        }
        return total_loan;
    }
    function deposit() public payable {
        require(Info[msg.sender].registered,"User Not registered");
        require(msg.value > 0, "Deposit amount must be greater than 0");
        Info[msg.sender].balances+= msg.value;
    }

    function loan_approval(uint256 amount) internal view returns(bool){
        require(Info[msg.sender].registered==true,"User Not registered");
        require(Info[msg.sender].PreviousLoanTime-block.timestamp<=6 minutes,"User Not registered");
        return amount<=Info[msg.sender].balances ;//- Info[msg.sender].PreviousLoanAmmount - Info[msg.sender].InterestPayable;
    }

    function defy_loan(uint256 amount) internal {
        require(loan_approval(amount), "Your Loan is not approved");
        uint256 Interest = (amount * 10) / 100;
        Info[msg.sender].loans.push(Loan(ID.current(), block.timestamp, amount, Interest));
        ID.increment(); // Increment the loan ID
        _transfer(owner(), msg.sender, amount);
    }

    function loan_return() internal{
    }
}

