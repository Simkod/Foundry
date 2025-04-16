// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SimpleBank} from "../src/SimpleBank.sol";

contract SimpleBankTest is Test {
    SimpleBank public bank;
    address public user = makeAddr("user");

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
        uint256 depositAmount = 1 ether;
        vm.deal(user, depositAmount); // Give the user some ETH
        uint256 before = user.balance;
        // Makes all subsequent transactions in the test (until vm.stopPrank() is called)
        // behave as if they were sent by the user address, i.e., msg.sender and tx.origin are set to user.
        vm.startPrank(user);
        bank.deposit{value: depositAmount}();
        assertEq(bank.getBalance(), depositAmount); //needs to run here so that msg.sender is the user
        vm.stopPrank();

        assertEq(user.balance, before - depositAmount);
        assertEq(address(bank).balance, depositAmount);
    }

    function test_Withdraw() public {
        //selector for test_withdraw - deposit 1 eth for user1 and 2eth for user 2
    }

    function testFuzz_Deposit(uint256 x) public {
    }

    function testFuzz_Withdraw(uint256 x) public {
    }
    
}
