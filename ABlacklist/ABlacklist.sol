// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

contract blacklist is Ownable{
    enum status{
        notblacklisted,
        blacklisted  
    }

    event AddressAddedToBlacklist(address user);
    event AddressRemovedFromBlacklist(address user);

    mapping (address=>status) userStatus;

    function AddBlacklisted(address a) public onlyOwner {
        userStatus[a] = status.blacklisted;
        emit AddressAddedToBlacklist(a);
    }

    function RemoveBlacklisted(address a) public onlyOwner {
        userStatus[a] = status.notblacklisted;
        emit AddressRemovedFromBlacklist(a);
    }
    
    function isBlacklisted(address a) public view returns(bool){
        return userStatus[a]==status.blacklisted;
    }
}