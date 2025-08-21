// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract BinarySearch {
    function search(uint256[] memory nums, uint256 target) public pure returns (int256) {
        uint256 left = 0;
        uint256 right = uint256(nums.length) - 1;
        while (left <= right) {
            int256 mid = int256((left + right) / 2);
            if (nums[uint256(mid)] == target) {
                return mid;
            } else if (nums[uint256(mid)] < target) {
                left = uint256(mid) + 1;
            } else {
                right = uint256(mid) - 1;
            }
        }

        return int256(-1);
    }
}   