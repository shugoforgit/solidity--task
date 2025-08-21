// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract IntToRoman {
    mapping(uint256 value => string roman) public intToRoman;

    constructor() {
        intToRoman[1] = "I";
        intToRoman[4] = "IV";
        intToRoman[5] = "V";
        intToRoman[9] = "IX";
        intToRoman[10] = "X";
        intToRoman[40] = "XL";
        intToRoman[50] = "L";
        intToRoman[90] = "XC";
        intToRoman[100] = "C";
        intToRoman[400] = "CD";
        intToRoman[500] = "D";
        intToRoman[900] = "CM";
        intToRoman[1000] = "M";
    }

    function int2roman(uint256 value) public view returns (string memory) {
        string memory result = "";
        uint256[13] memory values = [uint256(1000), uint256(900), uint256(500), uint256(400), uint256(100), uint256(90), uint256(50), uint256(40), uint256(10), uint256(9), uint256(5), uint256(4), uint256(1)];
        
        for (uint256 i = 0; i < values.length; i++) {
            while (value >= values[i]) {
                result = string(abi.encodePacked(result, intToRoman[values[i]]));
                value -= values[i];
            }
        }
        return result;
    }
}