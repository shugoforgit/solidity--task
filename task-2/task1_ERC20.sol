// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


contract MyToken {
    string public name = "MyToken";
    string public symbol = "MTK";
    uint8 public decimals = 18;
    uint256 public _totalSupply = 1000000000000000000000000;
    bool private _locked = false;
    mapping(address => uint256) public _balance;
    mapping(address => mapping(address => uint256)) public _allowance;
    address public _owner;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        _balance[msg.sender] = _totalSupply;
        _owner = msg.sender;
    }

    modifier nonReentrant() {
        require(!_locked, "Reentrant call");
        _locked = true;
        _;
        _locked = false;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "Only owner can call this function");
        _;
    }

    function transfer(address to, uint256 amount) external nonReentrant returns (bool) {
        require(_balance[msg.sender] >= amount, "Insufficient balance");
        require(to != address(0), "Invalid address");

        _balance[msg.sender] -= amount;
        _balance[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external nonReentrant returns (bool) {
        _allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external nonReentrant returns (bool) {
        require(_allowance[from][msg.sender] >= amount, "Insufficient allowance");
        require(_balance[from] >= amount, "Insufficient balance");
        require(to != address(0), "Invalid address");

        _allowance[from][msg.sender] -= amount;
        _balance[from] -= amount;
        _balance[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    function mint(uint256 amount) external onlyOwner nonReentrant {
        _balance[msg.sender] += amount;
        _totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balance[account];
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowance[owner][spender];
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }
}