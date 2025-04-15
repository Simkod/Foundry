// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import {SimpleBank} from "../src/SimpleBank.sol";

contract SimpleBankScript is Script {
    SimpleBank public bank;

    function run() public {
        vm.startBroadcast();

        bank = new SimpleBank();
        console.log("SimpleBank deployed at:", address(bank));

        vm.stopBroadcast();
    }
}
