// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {IGovernor, Delegatable} from "../src/Delegatable.sol";

interface IVotes {
    function delegate(address delegatee) external;
}

contract DelegatableTest is Test {
    Delegatable delegatable;
    address immutable VELODROME_MANAGER = 0xE4553b743E74dA3424Ac51f8C1E586fd43aE226F;
    address immutable VOTES_TOKEN = 0x4200000000000000000000000000000000000042; // OP token
    address immutable GOVERNOR = 0xcDF27F107725988f2261Ce2256bDfCdE8B382B10; // Velodrome contract
    address delegate = 0x94Db037207F6fB697DBd33524aaDffD108819DC8; // Joxes
    address tokenHolder = 0xb6F5414bAb8d5ad8F33E37591C02f7284E974FcB; // Filosofia Codigo
    uint proposalId;

    function setUp() public {
        // Let's start by launching a delegatable contract
        delegatable = new Delegatable();
        // The owner sets the delegate
        delegatable.setDelegate(delegate);
        // An token holder delegates to the contract
        vm.prank(tokenHolder);
        IVotes(VOTES_TOKEN).delegate(address(delegatable));

        // We finish this setup by creating a dummy proposal
        address[] memory targetAddresses = new address[](1);
        uint[] memory values = new uint[](1);
        bytes[] memory calldatas = new bytes[](1);
        targetAddresses[0] = address(0);
        values[0] = 0;
        calldatas[0] = "";
        
        vm.prank(VELODROME_MANAGER);
        proposalId = IGovernor(GOVERNOR).propose(
            targetAddresses,
            values,
            calldatas,
            "Dummy proposal");
        
        // In this case, voting starts in the next block, so let's roll a block
        vm.roll(block.number + 1);
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
