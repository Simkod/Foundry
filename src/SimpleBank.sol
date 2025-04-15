// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/Strings.sol";

contract SimpleBank {
    mapping(address => uint256) private balances;

    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);

    function deposit() external payable{
        require(msg.value > 0, "A Deposit must be greater than zero!");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external payable{
        require(amount > 0, "A Withdrawal must be greater than zero!");
        require(balances[msg.sender] >= amount, "Insufficent balance for withdrawal! Your Balance:" + balances[msg.sender].toString());

        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);

        emit Withdrawal(msg.sender, amount);
    }

    function getBalance() external view returns (uint256){
        return balances[msg.sender];
    }
}
