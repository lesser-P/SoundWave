// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@sushiswap/core/contracts/uniswapv2/interfaces/IUniswapV2Factory.sol";
import "@sushiswap/core/contracts/uniswapv2/interfaces/IUniswapV2Router02.sol";
import "@sushiswap/core/contracts/uniswapv2/interfaces/IUniswapV2Pair.sol";
import "./SoundWaveNFT.sol";

contract buyTicketLogic is Ownable, ReentrancyGuard {
    address private reciveEth;
    SoundWaveNFT swNFT;

    constructor(address _swNFT) {
        swNFT = SoundWaveNFT(_swNFT);
    }

    receive() external payable {}

    // 购买NFT
    function buyTickets(
        uint256 showId,
        uint256[] calldata ticketNos,
        uint256 amount
    ) external payable {
        uint256 _price = swNFT.getShowInfo(showId).price;
        require(amount * _price == msg.value, "not enought eth");
        require(amount == ticketNos.length, "amount and ticketNos not Match");

        //在这里做质押挖矿

        for (uint i = 0; i < amount; i++) {
            swNFT.mintFromExecutor(msg.sender, showId, ticketNos[i]);
        }
    }

    function claimAll() public onlyOwner returns (uint256) {
        uint256 eth = address(this).balance;
        payable(reciveEth).transfer(eth);
        return eth;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
