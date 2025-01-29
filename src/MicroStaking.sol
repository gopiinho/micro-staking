// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {ERC20} from "solmate/tokens/ERC20.sol";
import {Owned} from "solmate/auth/Owned.sol";

contract Token is ERC20, Owned {
    constructor() ERC20("Token", "TKN", 18) Owned(msg.sender) {}

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }
}

contract MicroStaking {
    Token public token;
    uint256 public s_lastUpdated;
    uint256 public s_growthRate;
    uint256 public s_rewardsPerShare;

    mapping(address => uint256) public s_staked;

    constructor(Token _token) {
        token         = _token;
        s_lastUpdated = block.timestamp;
        s_growthRate  = 10e18;
    }

    modifier update() {
        _;
    }

    function stake(uint256 amount) external {
        require(amount >= token.balanceOf(msg.sender), "Not enough tokens!");
        token.transferFrom(msg.sender, address(this), amount);
        s_staked[msg.sender] += amount;
    }

    function unstake(uint256 amount) external {
        require(s_staked[msg.sender] >= amount, "Not enough staked!");
        token.transfer(msg.sender, amount);
        s_staked[msg.sender] -= amount;
    }
}
