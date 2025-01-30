// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Token} from "./Token.sol";

contract MicroStaking {
    Token public token;
    uint256 public s_lastUpdated;
    uint256 public s_growthRate;
    uint256 public s_rewardsPerShare;

    mapping(address => uint256) public s_userStaked;
    mapping(address => uint256) public s_debt;

    constructor(Token _token) {
        token         = _token;
        s_lastUpdated = block.timestamp;
        s_growthRate  = 10e18;
    }

    modifier update(uint256 amount) {
        require(amount > 0, "Amount must be greater than 0!");
        uint256 timePassed  = block.timestamp - s_lastUpdated;
        s_lastUpdated       = block.timestamp;
        uint256 minted      = timePassed * s_rewardsPerShare;
        uint256 totalStaked = s_userStaked[address(this)];
        if(totalStaked > 0) {
            s_rewardsPerShare += (minted * 1e18) / totalStaked;
        }
        uint256 rewards = s_userStaked[msg.sender] * s_rewardsPerShare / 1e18 - s_debt[msg.sender];
        token.mint(msg.sender, rewards);
        _;
    }

    function stake(uint256 amount) external update(amount) {
        require(amount >= token.balanceOf(msg.sender), "Not enough tokens!");
        token.transferFrom(msg.sender, address(this), amount);
        s_userStaked[msg.sender] += amount;
        s_debt      [msg.sender] += s_userStaked[msg.sender] * s_rewardsPerShare / 1e18;
    }

    function unstake(uint256 amount) external update(amount) {
        require(s_userStaked[msg.sender] >= amount, "Not enough staked!");
        token.transfer(msg.sender, amount);
        s_userStaked[msg.sender] -= amount;
        s_debt      [msg.sender] += s_userStaked[msg.sender] * s_rewardsPerShare / 1e18;
    }
}
