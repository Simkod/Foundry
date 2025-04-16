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
        if (testSelector == this.test_Withdraw_InsufficientBalance.selector  ||
            testSelector == this.test_Withdraw.selector) {
            beforeTestCalldata = new bytes[](1);
            beforeTestCalldata[0] = abi.encodeWithSelector(this.setupDeposit.selector);
            }
        return beforeTestCalldata;
    }

    // Helper function to fund user and deposit 1 ETH
    function setupDeposit() public {
        vm.deal(user, 1 ether); // Fund user with 1 ETH
        vm.prank(user);
        bank.deposit{value: 1 ether}(); // Deposit as user
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

    function test_Deposit_Zero() public {
        vm.expectRevert(SimpleBank.ZeroDeposit.selector);
        bank.deposit{value: 0}();
    }

/*
    function testFuzz_Deposit(uint256 x) public {
        uint256 depositAmount = x;
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
    */

    function test_Withdraw() public {
        //assertEq(user.balance, 1 ether);
    }

    function test_Withdraw_InsufficientBalance() public {
        // Attempt to withdraw 2 ETH (more than balance)
        vm.prank(user); // Note: only next call will be from user's thanks to vm.prank()
        vm.expectRevert(SimpleBank.InsufficentBalance.selector);
        bank.withdraw(2 ether);
    }

    function test_Withdraw_Zero() public {
        vm.expectRevert(SimpleBank.ZeroWithdrawal.selector);
        bank.withdraw(0);
    }

    function testFuzz_Withdraw(uint256 x) public {
    }
    
}
