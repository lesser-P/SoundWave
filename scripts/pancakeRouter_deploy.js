const { ethers } = require('hardhat')
async function main() {
  const factory = await ethers.getContractFactory('PancakeRouter')
  const router = await factory.deploy(
    '0x82e01223d51Eb87e16A03E24687EDF0F294da6f1',
    '0xb7278A61aa25c888815aFC32Ad3cC52fF24fE575'
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
