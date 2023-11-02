const { ethers } = require('hardhat')
require('dotenv').config('')
const { pancakeFactory, pancakeRouter, weth, swToken } = require('../address')
const abi = require('../contracts/uniswap/artifacts/PancakeRouter.json')
const wethAbi = require('../contracts/artifacts/WETH.json')
const swAbi = require('../contracts/artifacts/SoundWaveToken.json')

const PRIVATE = process.env.PRIVATE_KEY
const RPC = process.env.SEPOLIA_RPC_HTTPS
const LocalPrivate = '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80'

async function main() {
  const provider = new ethers.JsonRpcProvider(RPC)
  const wallet = new ethers.Wallet(PRIVATE, provider)
  const myAddress = await wallet.getAddress()
  const pancakeRouterContract = new ethers.Contract(pancakeRouter, abi.abi, wallet)

  console.log('========授权========')
  const wethContract = new ethers.Contract(weth, wethAbi.abi, wallet)
  const swTokenContract = new ethers.Contract(swToken, swAbi.abi, wallet)
  const ap1 = await wethContract.approve(pancakeRouter, ethers.parseEther('10'))
  console.log(ap1)
  await swTokenContract.approve(pancakeRouter, ethers.parseEther('10'))

  console.log('=============开始添加流动性=============')
  const tx = pancakeRouterContract.addLiquidity(
    weth,
    swToken,
    '1000000',
    '1000000',
    0,
    0,
    myAddress,
    1737388491, //2025
    { gasLimit: 3000000 }
  )
  console.log(tx)
  await tx
  console.log('===========RESULT============')
  console.log(tx)
}
async function test() {
  const data =
    '0xe8e337000000000000000000000000000f70e0365fd9fdb166ec4424b78650da20d1ba070000000000000000000000000d43402e3cfb6bb086b17a001312bf3f2310b8ea00000000000000000000000000000000000000000000000000000000000f424000000000000000000000000000000000000000000000000000000000000f424000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f5acd7df01a57360e8e53ac2d28b8452ec0efcc600000000000000000000000000000000000000000000000000000000678e71cb'
  const itface = new ethers.Interface(abi.abi)
  const result = itface.parseTransaction({ data })
  console.log(result)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error)
    process.exit(-1)
  })
