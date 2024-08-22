// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

//import {console} from "forge-std/console.sol";

contract Wallet {
    /// errors

    error Wallet__InsufficientEther(uint256 amount);

    event Deposit(address indexed user, uint256 amount, uint256 unlockTime);

    struct DepositInfo {
        uint256 amount;
        uint256 unlockTime;
    }

    address private immutable i_owner;
    mapping(address user => DepositInfo) private s_usersToDeposits;
    uint256 public constant MIN_DEPOSIT = 0.001 ether;

    modifier enoughEther() {
        //solidity 0.8.26, viaIr
        //require(msg.value >= MIN_DEPOSIT, Wallet__InsufficientEther(msg.value));

        //console.log("msg.value:", msg.value);
        if (msg.value < MIN_DEPOSIT) {
            revert Wallet__InsufficientEther(msg.value);
        }
        _;
    }

    constructor(address owner) {
        i_owner = owner;
    }

    function deposit(uint256 delay) external payable enoughEther {
        uint256 unlockTime = block.timestamp + delay;
        s_usersToDeposits[msg.sender] = DepositInfo({
            amount: msg.value,
            unlockTime: unlockTime
        });
        emit Deposit(msg.sender, msg.value, unlockTime);
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
}
