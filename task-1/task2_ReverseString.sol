// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract ReverseString {
    function reverse(string memory s) public pure returns (string memory) {
        bytes memory b = bytes(s);
        for (uint i = 0; i < b.length / 2; i++) {
            bytes1 temp = b[i];
            b[i] = b[b.length - i - 1];
            b[b.length - i - 1] = temp;
        }
        return string(b);
    }
}