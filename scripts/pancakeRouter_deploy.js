const { ethers } = require('hardhat')
require('dotenv').config('')
async function main() {
  const provider = new ethers.JsonRpcProvider('http://127.0.0.1:8545')
  const number = await provider.getBlockNumber()
  const factory = await ethers.getContractFactory('PancakeRouter')
  console.log('number:', number)
  const router = await factory.deploy(
    '0x82e01223d51Eb87e16A03E24687EDF0F294da6f1',
    '0xb7278A61aa25c888815aFC32Ad3cC52fF24fE575',
    { gasLimit: 25000000000, gasPrice: 100000000000 }
  )
  await router.waitForDeployment()
  console.log('router:', router.target)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error)
    process.exit(-1)
  })
