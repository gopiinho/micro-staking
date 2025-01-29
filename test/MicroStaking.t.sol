// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Test.sol";

import {Token, MicroStaking} from "../src/MicroStaking.sol";

contract MicroStakingTest is Test {
    Token token;
    MicroStaking microStaking;

    function setUp() public {
        token        = new Token();
        microStaking = new MicroStaking(token);
    }
}
