// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract KYC {
    struct details {
        string name;
        string contact;
        string residenceAddress;
        string aadharNumber;
    }

    mapping(address => details) private user;

    function setDetails(string memory _name, string memory _contact, string memory _residenceAddress, string memory _aadharNumber) public {
        user[msg.sender] = details(_name, _contact, _residenceAddress, _aadharNumber);
    }

    function getDetails(address ad) public view returns (string memory name, string memory contact, string memory residenceAddress, string memory aadharNumber) {
        details memory info = user[ad];
        return (info.name, info.contact, info.residenceAddress, info.aadharNumber);
    }
}
