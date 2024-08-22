// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {Wallet} from "src/Wallet.sol";
import {DeployWallet} from "script/DeployWallet.s.sol";

contract TestWallet is Test {
    Wallet wallet;

    address owner = makeAddr("owner");
    address alice = makeAddr("alice");

    function setUp() external {
        DeployWallet deployer = new DeployWallet();
        wallet = deployer.run(owner);
    }

    /// CONSTUCTOR
    function test_ConstructorInitsOwner() external view {
        address realOwner = wallet.getOwner();
        assertEq(realOwner, owner);
    }

    /// DEPOSIT
    function test_DepositRevertsIfNotEnoughEtherSent() external {
        //vm.deal(alice, 0.0001 ether);//начислить
        //vm.prank(alice);

        uint256 startBalance = 0.0001 ether;
        uint256 unlockTime = 1;
        hoax(alice, startBalance); //prank && deal
        vm.expectRevert(
            abi.encodeWithSelector(
                Wallet.Wallet__InsufficientEther.selector,
                startBalance
            )
        );

        wallet.deposit{value: startBalance}(unlockTime);
    }

    function test_DepositRevertsIfNotEnoughEtherSentBoundaryValues() external {
        uint256 lowerBound = 0;
        uint256 unlockTime = 1;

        vm.prank(alice);
        vm.expectRevert(
            abi.encodeWithSelector(
                Wallet.Wallet__InsufficientEther.selector,
                lowerBound
            )
        );
        wallet.deposit{value: lowerBound}(unlockTime);

        uint256 upperBound = wallet.MIN_DEPOSIT() - 1;

        hoax(alice, upperBound); //prank && deal
        vm.expectRevert(
            abi.encodeWithSelector(
                Wallet.Wallet__InsufficientEther.selector,
                upperBound
            )
        );
        wallet.deposit{value: upperBound}(unlockTime);
    }

    function testFuzz_DepositRevertsIfNotEnoughEtherSent(
        uint256 startBalance
    ) external {
        //vm.assume(startBalance < wallet.MIN_DEPOSIT());
        startBalance = bound(startBalance, 0, wallet.MIN_DEPOSIT() - 1);

        uint256 unlockTime = 1;
        hoax(alice, startBalance); //prank && deal
        vm.expectRevert(
            abi.encodeWithSelector(
                Wallet.Wallet__InsufficientEther.selector,
                startBalance
            )
        );
        wallet.deposit{value: startBalance}(unlockTime);
    }
}
