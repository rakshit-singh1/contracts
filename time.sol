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
    function timestampToDate(uint256 timestamp) public pure returns (string memory) {
        require(timestamp > 0, "Timestamp must be greater than 0");

        uint256 year;
        uint256 month;
        uint256 day;

        uint8[12] memory daysPerMonth;
        daysPerMonth[0] = 31;
        daysPerMonth[1] = 28;
        daysPerMonth[2] = 31;
        daysPerMonth[3] = 30;
        daysPerMonth[4] = 31;
        daysPerMonth[5] = 30;
        daysPerMonth[6] = 31;
        daysPerMonth[7] = 31;
        daysPerMonth[8] = 30;
        daysPerMonth[9] = 31;
        daysPerMonth[10] = 30;
        daysPerMonth[11] = 31;

        uint256 secondsInDay = 86400;  // 24 hours in seconds
        uint256 secondsInYear = 31536000;  // 365 days in seconds

        year = timestamp / secondsInYear;
        timestamp %= secondsInYear;

        uint256 daysInMonth;

        for (month = 0; month < 12; month++) {
            daysInMonth = uint256(daysPerMonth[month]) * secondsInDay;
            if (timestamp < daysInMonth) {
                day = timestamp / secondsInDay + 1;
                break;
            }
            timestamp -= daysInMonth;
        }

        month++;  // Months are 1-based

        return string(abi.encodePacked(uintToString(day), "days", uintToString(month), "months", uintToString(year % 100), "years"));
    }

    function uintToString(uint256 v) internal pure returns (string memory str) {
        uint256 maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint256 i = 0;
        while (v != 0) {
            uint256 remainder = v % 10;
            v = v / 10;
            reversed[i++] = bytes1(uint8(48 + remainder));
        }

        bytes memory s = new bytes(i); // Trim down to actual size
        for (uint256 j = 0; j < i; j++) {
            s[j] = reversed[i - 1 - j];
        }
        str = string(s);
    }
}