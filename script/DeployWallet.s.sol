// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {Wallet} from "src/Wallet.sol";

contract DeployWallet is Script {
    function run(address owner) external returns (Wallet wallet) {
        vm.broadcast();
        wallet = new Wallet(owner);
    }
}
