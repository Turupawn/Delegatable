// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

interface IGovernor is Ownable {
    function propose(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description
    ) external returns (uint256 proposalId);

    function castVoteWithReason(
        uint256 proposalId,
        uint8 support,
        string calldata reason
    ) external returns (uint256 balance);
}

contract Counter {
    address public delegate;

    function setDelegate(address delegate_) onlyOwner {
        delegate = delegate_;
    }

    function castVote(
        address governorAddress,
        uint256 proposalId,
        uint8 support,
        string calldata reason) {
        require(msg.sender == delegate, "Only delegate can cast votes");
        IGovernor(governorAddress).castVoteWithReason(proposalId, support, reason);
    }
}
