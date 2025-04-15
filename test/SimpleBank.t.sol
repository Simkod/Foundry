// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SimpleBank} from "../src/SimpleBank.sol";

contract SimpleBankTest is Test {
    SimpleBank public bank;

    function setUp() public {
        bank = new SimpleBank();
    }

    /*
     * @notice Optional function that configures a set of transactions to be executed before test.
     * @param testSelector elector of the test for which transactions are applied.
     */
    function beforeTestSetup(bytes4 testSelector) public returns (bytes[] memory beforeTestCalldata) {
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
