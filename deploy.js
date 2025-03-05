const hre = require("hardhat");

async function main() {
  // Get the contract factory
  const CrowdfundingWithNFTs = await hre.ethers.getContractFactory("CrowdfundingWithNFTs");

  // Deploy the contract
  const contract = await CrowdfundingWithNFTs.deploy("CrowdNFT", "CNFT");

  await contract.waitForDeployment();
  console.log(`Contract deployed to: ${await contract.getAddress()}`);
}

// Execute deployment
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
