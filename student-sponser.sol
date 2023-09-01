// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
contract Manager{
    mapping(address=>string) UserType;
    string type1;
    string type2;
    constructor(string memory _type1,string memory _type2) {
        type1=_type1;
        type2=_type2;
    }
    mapping(address=>bool) UserRegistered;
    function Register(string memory t) public{
        require(!UserRegistered[msg.sender],"User already Registered");
        require(keccak256(abi.encodePacked(t))==keccak256(abi.encodePacked(type1)) || keccak256(abi.encodePacked(t))==keccak256(abi.encodePacked(type2)),"User already Registered");
        UserRegistered[msg.sender]=true;
        UserType[msg.sender] = t;
    }
    function isUserType(address a) public view returns (string memory) {
        return UserType[a];
    }
    function isUserRegistered(address a) public view returns (bool) {
        return UserRegistered[a];
    }
}