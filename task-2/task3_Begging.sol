// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BeggingContract {
    address public owner;
    uint256 public totalDonations;
    mapping(address => uint256) public donations;

    // 排行榜相关变量
    address[3] public topDonors;        // 前三名捐赠者地址
    uint256[3] public topAmounts;       // 对应的捐赠金额

    constructor() {
        owner = msg.sender;
    }

    event Donation(address indexed donor, uint256 amount);
    event LeaderboardUpdated(address indexed donor, uint256 newAmount, uint256 rank);

    // 修饰符：只有所有者可以执行
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    // 捐赠函数 - 使用 payable 修饰符接收以太坊
    function donate() public payable {
        require(msg.value > 0, "Donation amount must be greater than 0");
        
        donations[msg.sender] += msg.value;
        totalDonations += msg.value;
        
        // 更新排行榜
        updateLeaderboard(msg.sender, donations[msg.sender]);

        emit Donation(msg.sender, msg.value);
    }

    function withdraw() public onlyOwner {
        require(address(this).balance > 0, "No funds to withdraw");
        payable(msg.sender).transfer(address(this).balance);
    }

    // 更新排行榜的内部函数
    function updateLeaderboard(address donor, uint256 totalAmount) internal {
        // 检查是否能进入前三名
        for (uint256 i = 0; i < 3; i++) {
            if (totalAmount > topAmounts[i]) {
                // 找到插入位置，向后移动其他排名
                for (uint256 j = 2; j > i; j--) {
                    topDonors[j] = topDonors[j-1];
                    topAmounts[j] = topAmounts[j-1];
                }
                
                // 插入新的排名
                topDonors[i] = donor;
                topAmounts[i] = totalAmount;
                
                emit LeaderboardUpdated(donor, totalAmount, i + 1);
                break;
            }
        }
    }

    // 查看指定捐赠者的捐赠金额
    function getDonations(address donor) public view returns (uint256) {
        return donations[donor];
    }

    // 获取排行榜前三名
    function getTopDonors() public view returns (
        address[3] memory donors,
        uint256[3] memory amounts
    ) {
        return (topDonors, topAmounts);
    }

    // 获取指定排名的捐赠者信息
    function getTopDonor(uint256 rank) public view returns (address donor, uint256 amount) {
        require(rank > 0 && rank <= 3, "Rank must be between 1 and 3");
        uint256 index = rank - 1;
        return (topDonors[index], topAmounts[index]);
    }

    // 检查某个地址是否在排行榜中
    function isInLeaderboard(address donor) public view returns (bool, uint256) {
        for (uint256 i = 0; i < 3; i++) {
            if (topDonors[i] == donor) {
                return (true, i + 1); // 返回是否在排行榜和排名
            }
        }
        return (false, 0);
    }
}