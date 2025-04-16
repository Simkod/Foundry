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
    function beforeTestSetup(bytes4 testSelector) public pure returns (bytes[] memory beforeTestCalldata) {
        if (testSelector == this.test_Withdraw_InsufficientBalance.selector ||
            testSelector == this.test_Withdraw.selector) {
            beforeTestCalldata = new bytes[](1);
            beforeTestCalldata[0] = abi.encodeWithSelector(this.setupDeposit.selector, 1 ether);
            }
        return beforeTestCalldata;
    }

    // Helper function to fund user
    function setupDeposit(uint256 amount) public {
        vm.deal(user, amount); // Fund user
        vm.prank(user);
        bank.deposit{value: amount}(); // Deposit as user
    }

    function test_Deposit() public {
        uint256 depositAmount = 1 ether;
        vm.deal(user, depositAmount); // Give the user some ETH
        uint256 before = user.balance;
        // Makes all subsequent transactions in the test (until vm.stopPrank() is called)
        // behave as if they were sent by the user address, i.e., msg.sender and tx.origin are set to user.
        vm.expectEmit(true, false, false, true);
        emit SimpleBank.Deposit(user, depositAmount);
        vm.startPrank(user);
        bank.deposit{value: depositAmount}();
        assertEq(bank.getUserBalance(), depositAmount); //needs to run here so that msg.sender is the user
        vm.stopPrank();

        assertEq(user.balance, before - depositAmount);
        assertEq(address(bank).balance, depositAmount);
    }

    function test_Deposit_Zero() public {
        vm.expectRevert(SimpleBank.ZeroDeposit.selector);
        bank.deposit{value: 0}();
    }


    function testFuzz_Deposit(uint256 amount) public {
        vm.assume(amount > 0 ether);

        vm.deal(user, amount); // Give the user some ETH
        uint256 before = user.balance;
        // Makes all subsequent transactions in the test (until vm.stopPrank() is called)
        // behave as if they were sent by the user address, i.e., msg.sender and tx.origin are set to user.
        vm.expectEmit(true, false, false, true);
        emit SimpleBank.Deposit(user, amount);
        vm.startPrank(user);
        bank.deposit{value: amount}();
        assertEq(bank.getUserBalance(), amount); //needs to run here so that msg.sender is the user
        vm.stopPrank();

        assertEq(user.balance, before - amount);
        assertEq(address(bank).balance, amount);
    }


    function test_Withdraw() public {
        uint256 withdrawAmount = 0.6 ether;
        uint256 startContractBalance = address(bank).balance;

        vm.startPrank(user);
        uint256 startUserBalance = bank.getUserBalance();

        vm.expectEmit(true, false, false, true);
        emit SimpleBank.Withdrawal(user, withdrawAmount);
        bank.withdraw(withdrawAmount);

        assertEq(bank.getUserBalance(), startUserBalance - withdrawAmount);
        vm.stopPrank();

        assertEq(address(bank).balance, startContractBalance - withdrawAmount);
        assertEq(user.balance, withdrawAmount);
    }

    function test_Withdraw_InsufficientBalance() public {
        vm.prank(user); // Note: only next call will be from user's thanks to vm.prank()
        vm.expectRevert(SimpleBank.InsufficentBalance.selector);
        bank.withdraw(2 ether); // Withdraw more than deposited
    }

    function test_Withdraw_Zero() public {
        vm.expectRevert(SimpleBank.ZeroWithdrawal.selector);
        bank.withdraw(0);
    }

    function testFuzz_Withdraw(uint256 depositAmount, uint256 withdrawAmount) public {
        vm.assume(depositAmount > 0);
        vm.assume(withdrawAmount > 0);
        vm.assume(withdrawAmount < depositAmount);
        setupDeposit(depositAmount);
        
        uint256 startContractBalance = address(bank).balance;

        vm.startPrank(user);
        uint256 startUserBalance = bank.getUserBalance();

        vm.expectEmit(true, false, false, true);
        emit SimpleBank.Withdrawal(user, withdrawAmount);
        bank.withdraw(withdrawAmount);

        assertEq(bank.getUserBalance(), startUserBalance - withdrawAmount);
        vm.stopPrank();

        assertEq(address(bank).balance, startContractBalance - withdrawAmount);
        assertEq(user.balance, withdrawAmount);
    }
    
}
