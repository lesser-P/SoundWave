// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@sushiswap/core/contracts/uniswapv2/interfaces/IUniswapV2Factory.sol";
import "@sushiswap/core/contracts/uniswapv2/interfaces/IUniswapV2Router02.sol";
import "@sushiswap/core/contracts/uniswapv2/interfaces/IUniswapV2Pair.sol";
import "./SoundWaveNFT.sol";
import "./WETH.sol";
import "./SoundWaveToken.sol";
import "../contracts/uniswap/PancakeRouter.sol";

contract buyTicketLogic is Ownable, ReentrancyGuard {
    address private reciveEth;
    SoundWaveNFT swNFT;
    WETH weth;
    PancakeRouter pancakeRouter;
    SoundWaveToken swToken;
    address recepiet;

    constructor(
        address _swNFT,
        address payable _weth,
        address _pancakeRouter,
        address _swToken,
        address _receipet
    ) {
        swNFT = SoundWaveNFT(_swNFT);
        weth = WETH(_weth);
        pancakeRouter = PancakeRouter(_pancakeRouter);
        swToken = SoundWaveToken(_swToken);
        recepiet = _receipet;
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
        //取出40%的eth来购买swToken
        uint256 ethRem = address(this).balance;

        uint256 buyToken = (ethRem * 40000) / 100000;
        weth.mint(address(this), buyToken);
        swToken.mint(address(this), buyToken);
        pancakeRouter.addLiquidity(
            weth,
            swToken,
            buyToken,
            buyToken,
            0,
            0,
            recepiet,
            block.timestamp + 100000
        );

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
