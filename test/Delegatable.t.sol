// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {IGovernor, Delegatable} from "../src/Delegatable.sol";

interface IVotes {
    function delegate(address delegatee) external;
}

contract DelegatableTest is Test {
    Delegatable delegatable;
    address immutable VOTES_TOKEN = 0x4200000000000000000000000000000000000042; // OP token
    address immutable GOVERNOR = 0x6E17cdef2F7c1598AD9DfA9A8acCF84B1303f43f; // Governor contract
    address delegate = 0x94Db037207F6fB697DBd33524aaDffD108819DC8; // Joxes, the delegate
    address tokenHolder = 0xb6F5414bAb8d5ad8F33E37591C02f7284E974FcB; // Filosofia Codigo, the delegator
    uint proposalId;

    function setUp() public {
        // In order to test this contract we will need to go back in time where there was an active proposal to test
        vm.roll(106147085);
        proposalId = 89320044424373681815246934685110221027039718080034540446478326550596924622672;

        // Let's start by launching a delegatable contract
        delegatable = new Delegatable();
        // The owner sets the delegate
        delegatable.setDelegate(delegate);
        // A token holder delegates to the contract
        vm.prank(tokenHolder);
        IVotes(VOTES_TOKEN).delegate(address(delegatable));
    }

    function testCastVote() public {
        // Now the delegate should be able to cast a vote
        vm.prank(delegate);
        delegatable.castVote(
            GOVERNOR,
            proposalId,
            1,
            "Dummy reason");
    }
}
