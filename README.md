# SoundWave

## 项目简介

该项目是一个演唱会门票的售卖项目，项目将门票的媒介变为 NFT 这种非同质化货币，保证每个门票座位的唯一性，限制该 NFT 的交易来保证门票不会被二次销售，在演唱会开始后可以通过验证该门票入场，演唱会结束后可以选择销毁 NFT 获得一定数量的 Token 作为奖励。

在 buyTicketLogic 合约收到 eth 后会用 eth 来购买一定数量的 Token 加入流动池来实现流动性挖矿。

# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```
