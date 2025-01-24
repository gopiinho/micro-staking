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

contract MicroStaking {}
