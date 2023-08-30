// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
contract abc{
    uint256 public startTime;
    uint256 public endTime;

    constructor(uint256 _durationInSeconds) {
        startTime = block.timestamp;
        endTime = startTime + _durationInSeconds;
    }

    function isContractActive() public view returns (bool) {
        return block.timestamp < endTime;
    }

    function getCurrentTime() public view returns (uint256) {
        return block.timestamp;
    }
}