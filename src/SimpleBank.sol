// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/Strings.sol";

contract SimpleBank {
    mapping(address => uint256) private balances;

    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);

    error ZeroDeposit();
    error ZeroWithdrawal();

    function deposit() external payable{
        if (msg.value == 0) revert ZeroDeposit();
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external payable{
        if (amount == 0) revert ZeroWithdrawal();
        require(balances[msg.sender] >= amount, string(abi.encodePacked("Insufficent balance for withdrawal! Your Balance: ", Strings.toString(balances[msg.sender]))));

        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);

        emit Withdrawal(msg.sender, amount);
    }

    function getBalance() external view returns (uint256){
        return balances[msg.sender];
    }
}
