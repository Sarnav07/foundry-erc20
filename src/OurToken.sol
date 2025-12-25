//SPDX-License-Identifer : MIT
pragma solidity ^0.8.30;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OurToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("SARNAV_07", "S7") {
        _mint(msg.sender, initialSupply);
    }
}
