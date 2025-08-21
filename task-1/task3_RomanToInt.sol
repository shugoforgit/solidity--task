// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract RomanToInt {
    mapping(string roman => uint256 value) public romanToInt;

    constructor() {
        romanToInt["I"] = 1;
        romanToInt["V"] = 5;
        romanToInt["X"] = 10;
        romanToInt["L"] = 50;
        romanToInt["C"] = 100;
        romanToInt["D"] = 500;
        romanToInt["M"] = 1000;
    }

    function roman2int(string memory s) public view returns (uint256) {
        uint256 result = 0;
        uint256 prevValue = 0;
        bytes memory b = bytes(s);
        for (uint256 i = 0; i < b.length; i++) {
            uint256 value = romanToInt[string(abi.encodePacked(b[i]))];
            if (value > prevValue) {
                result += value - 2 * prevValue;
            } else {
                result += value;
            }
            prevValue = value;
        }
        return result;
    }
}
