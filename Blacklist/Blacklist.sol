// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

contract blacklist is Ownable{
    enum status{
        notblacklisted,
        blacklisted  
    }
    mapping (address=>status) userStatus;

    function AddBlacklisted(address a) public onlyOwner {
        userStatus[a]=status.blacklisted;
    }
    function RemoveBlacklisted(address a) public onlyOwner {
        userStatus[a]=status.notblacklisted;
    }
    function isBlacklisted(address a) public view returns(bool){
        return userStatus[a]==status.blacklisted;
    }
}