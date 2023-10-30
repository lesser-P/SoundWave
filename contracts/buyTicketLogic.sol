// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./SoundWaveNFT.sol";

contract buyTicketLogic is Ownable, ReentrancyGuard {
    address private reciveEth;

    receive() external payable {}

    // 购买NFT
    function buyTickets(
        uint256 showId,
        uint256 ticketNo,
        uint256 amount
    ) external payable {}

    function claimAll() public onlyOwner returns (uint256) {
        uint256 eth = address(this).balance;
        payable(reciveEth).transfer(eth);
        return eth;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
