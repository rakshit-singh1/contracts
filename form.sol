// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract forms{
    struct Details{
        string name;
        uint addhar;
        bytes32 hashcode;
    }
    Details[] list;
    mapping(bytes32=>uint) hashToIndex;

    function initiallize(string memory _name,  uint _addhar) public returns(string memory,bytes32){
        bytes32 hash = keccak256(abi.encodePacked(_name,_addhar));

        Details memory d1 = Details(_name,_addhar,hash);
        list.push(d1);

        hashToIndex[hash] = list.length-1;

        return ("Your Hash is ",hash);
    }

    function getDetails(bytes32 _hash) public view returns(Details memory){
        uint index = hashToIndex[_hash];
        require(index<list.length,"Data Not Available");

        return list[index];
    } 
}