// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Voting {
    mapping(string candidate => uint8 voteCount) public voted;
    
    constructor() {
        voted["A"] = 0;
        voted["B"] = 0;
        voted["C"] = 0;
    }

    function vote(string memory candidate) external {
        voted[candidate]++;
    }

    function getVoteCount(string memory candidate) external view returns (uint8) {
        return voted[candidate];
    }

    function resetVotes() external {
        voted["A"] = 0;
        voted["B"] = 0;
        voted["C"] = 0;
    }
}