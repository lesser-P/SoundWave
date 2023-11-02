require('dotenv').config()
require('@nomicfoundation/hardhat-toolbox')
// require("@nomiclabs/hardhat-etherscan");
require('hardhat-gas-reporter')
require('mocha')

// const SEPOLIA_RPC = process.env.SEPOLIA_RPC_HTTPS;
const PRIVATE_KEY = process.env.PRIVATE_KEY
// const APIKEY = process.env.VRFaddress

// console.log('API', APIKEY)

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    localhost: {
      url: 'http://127.0.0.1:8545',
      accounts: ['0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80'],
      live: true,
      gas: 25000000000,
    },
    sepolia: {
      url: 'https://sepolia.infura.io/v3/200c1554096d4b7aa08be1cba45e9e19',
      accounts: ['6eb736ab4da6fc7139a88d710eb8c0db47d4f94c2e6e4311ea2ef17c8743d325'],
      live: true,
      saveDeployments: true,
      timeout: 10000000,
    },
    mubai: {
      url: process.env.Polygon_Mumbai,
      accounts: ['6eb736ab4da6fc7139a88d710eb8c0db47d4f94c2e6e4311ea2ef17c8743d325'],
      live: true,
      saveDeployments: true,
      tags: ['staging'],
      gas: 50000000,
      timeout: 10000000,
    },
    fuji: {
      url: 'https://api.avax-test.network/ext/C/rpc',
      accounts: [PRIVATE_KEY],
      chainId: 43113,
      live: true,
      saveDeployments: true,
      tags: ['staging'],
      gas: 25000000000,
      timeout: 10000000,
    },
  },
  // etherscan: {
  //   apiKey: APIKEY,
  // },
  solidity: {
    settings: {
      optimizer: {
        enabled: true,
        runs: 1,
      },
    },
    compilers: [
      {
        version: '0.8.7',
      },
      {
        version: '0.6.6',
      },
      {
        version: '0.4.18',
      },
      {
        version: '0.5.16',
      },
      {
        version: '0.8.18',
      },
      {
        version: '0.6.6',
      },
      {
        version: '0.8.9',
      },
    ],
  },
  gasReporter: {
    currency: 'CHF',
    gasPrice: 21,
  },
  etherscan: {
    apiKey: {
      sepolia: 'U7HUDBUKVSZ3NMXKXFK89AMUIICF4Y6BGH',
    },
  },
}
