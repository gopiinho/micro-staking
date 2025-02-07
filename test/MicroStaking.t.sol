// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import {Token, MicroStaking} from "../src/MicroStaking.sol";

contract MicroStakingTest is Test {
    Token token;
    MicroStaking microStaking;

    address USER;
    uint256 constant MINT_AMOUNT = 10000e18;

    function setUp() public {
        USER         = makeAddr("USER");
        vm.startPrank(address(USER));
        token        = new Token();
        microStaking = new MicroStaking(token);        
        token.mint(USER, MINT_AMOUNT);    
        vm.stopPrank();
        vm.deal(USER, 1 ether);
    }

    modifier userStakes() {
        vm.startPrank(USER);
        token.approve(address(microStaking), MINT_AMOUNT);
        microStaking.stake(MINT_AMOUNT);
        vm.stopPrank();
        _;
    }

    function testUserCanStake() public {
        vm.startPrank(USER);
        token.approve(address(microStaking), MINT_AMOUNT);
        microStaking.stake(MINT_AMOUNT);
        vm.stopPrank();

        uint256 userStakingBalance = microStaking.s_userStaked(USER);
        assertEq(userStakingBalance, MINT_AMOUNT);
    }

    function testUserCanUnstake() public userStakes {
        uint256 unstakeAmount    = 1000e18;
        uint256 userStakedAmount = microStaking.s_userStaked(USER);
        vm.startPrank(USER);
        microStaking.unstake(unstakeAmount);
        vm.stopPrank();
        assertEq(microStaking.s_userStaked(USER), userStakedAmount - unstakeAmount);
    }
}
