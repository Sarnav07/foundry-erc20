//SPDX-License-identifier : MIT
pragma solidity ^0.8.30;

import {Test} from "../lib/forge-std/src/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address sarnav = makeAddr("Sarnav");
    address kansal = makeAddr("Kansal");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(sarnav, STARTING_BALANCE);
    }

    function testSarnavBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(sarnav));
    }

    function testAllowancesWorks() public {
        uint256 initialAllowance = 1000; // sarnav allows kansal to spend token on his behalf

        vm.prank(sarnav);
        ourToken.approve(kansal, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(kansal);
        ourToken.transferFrom(sarnav, kansal, transferAmount);

        assertEq(ourToken.balanceOf(kansal), transferAmount);
        assertEq(ourToken.balanceOf(sarnav), STARTING_BALANCE - transferAmount);
    }

    function testInitialSupply() public view {
        assertEq(ourToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testUsersCantMint() public {
        vm.expectRevert();
        MintableToken(address(ourToken)).mint(address(this), 1);
    }
}

