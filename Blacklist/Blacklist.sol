// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract blacklist{
    event black(address owner);
    enum status{
        notblacklisted,
        blacklisted  
    }
    mapping (address=>status) userStatus;

    function AddBlacklisted(address a) public {
        userStatus[a]=status.blacklisted;
    }
    function RemoveBlacklisted(address a) public {
        userStatus[a]=status.notblacklisted;
    }
    function isBlacklisted(address a) public view returns(bool){
        return userStatus[a]==status.blacklisted;
    }
    
}