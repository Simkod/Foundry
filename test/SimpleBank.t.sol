// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SimpleBank} from "../src/SimpleBank.sol";

contract SimpleBankTest is Test {
    SimpleBank public bank;

    function setUp() public {
        bank = new SimpleBank();
    }

    function test_Deposit() public {
    }

    function test_Withdraw() public {
    } 

    function testFuzz_Deposit(uint256 x) public {
    }

    function testFuzz_Withdraw(uint256 x) public {
    }
    
}
