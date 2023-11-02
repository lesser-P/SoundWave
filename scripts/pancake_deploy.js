const { ethers } = require('hardhat')

async function main() {
  const wethFactory = await ethers.getContractFactory('WETH')
  const wethContract = await wethFactory.deploy({ value: ethers.parseEther('0.1') })
  const soundWaveFactory = await ethers.getContractFactory('SoundWaveToken')
  const soundWaveTokenContract = await soundWaveFactory.deploy({ value: ethers.parseEther('0.1') })
  await soundWaveTokenContract.waitForDeployment()
  await wethContract.waitForDeployment()

  console.log('weth:', wethContract.target)
  console.log('swToken', soundWaveTokenContract.target)

  const pancakeFactory = await ethers.getContractFactory('PancakeFactory')
  const pancakeFContract = await pancakeFactory.deploy('0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266')
  await pancakeFContract.waitForDeployment()
  console.log('pancakeFactory:', pancakeFContract.target)
  const tx = await pancakeFContract.createPair(wethContract.target, soundWaveTokenContract.target)
  await tx.wait()
  const pairAddr = await pancakeFContract.getPair(
    wethContract.target,
    soundWaveTokenContract.target
  )
  console.log('pairAddr', pairAddr)
  const init_code = await pancakeFContract.INIT_CODE_PAIR_HASH()
  console.log('initCode', init_code)
  //   //注意是否需要修改Router中的hex
  //   const routerFactory = await ethers.getContractFactory('PancakeRouter')
  //   const router = await routerFactory.deploy(pancakeFContract.target, wethContract.target, {
  //     gasLimit: 3000000000,
  //   })
  //   await router.waitForDeployment()
  //   console.log('router:', router.target)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error)
    process.exit(-1)
  })
