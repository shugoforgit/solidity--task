// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract MergeSortedArray {
    function merge(uint256[] memory nums1, uint256 m, uint256[] memory nums2, uint256 n) public pure returns (uint256[] memory) {
        uint256[] memory result = new uint256[](m + n);
        uint256 i = 0;
        uint256 j = 0;
        uint256 k = 0;
        while (i < m && j < n) {
            if (nums1[i] < nums2[j]) {
                result[k++] = nums1[i++];
            } else {
                result[k++] = nums2[j++];
            }
        }
        while (i < m) {
            result[k++] = nums1[i++];
        }
        while (j < n) {
            result[k++] = nums2[j++];
        }
        return result;
    }
}