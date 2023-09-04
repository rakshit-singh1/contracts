// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "./getSmart.sol";

contract Manager is Smart{
    mapping(address=>string) private UsersType;
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
}