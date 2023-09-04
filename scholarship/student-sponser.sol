// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "./getSmart.sol";

contract Manager is Smart{
    mapping(address=>string) private UsersType;
    string typeSponser;
    string typeStudent;
    constructor(string memory _typeSponser,string memory _typeStudent) {
        typeSponser=_typeSponser;
        typeStudent=_typeStudent;
    }
    mapping(address=>bool) UserRegistered;
    function Register(string memory t) public{
        require(!UserRegistered[msg.sender],"User already Registered");
        require(keccak256(abi.encodePacked(t))==keccak256(abi.encodePacked(typeSponser)) || keccak256(abi.encodePacked(t))==keccak256(abi.encodePacked(typeStudent)),"User already Registered");
        UserRegistered[msg.sender]=true;
        UsersType[msg.sender] = t;
    }

    function UserType(address a) public view returns (string memory) {
        return UsersType[a];
    }

    function UserType() public view returns (string memory) {
        return UsersType[msg.sender];
    }

    function isUserRegistered() public view returns (bool) {
        return UserRegistered[msg.sender];
    }

    function isUserRegistered(address a) public view returns (bool) {
        return UserRegistered[a];
    }

    function buyTokens(uint256 _numTokens) external payable {
        uint256 totalCost = _numTokens * tokenPrice;
        require(msg.value >= totalCost, "Insufficient ethers sent");
        require(keccak256(abi.encodePacked(UsersType[msg.sender]))==keccak256(abi.encodePacked(typeSponser)), "You are not allowed to buy");
        require(balanceOf(owner()) >= _numTokens, "Not enough tokens in owner's balance");
        _transfer(owner(),msg.sender,_numTokens);
    }
}