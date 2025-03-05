const { ethers } = require("hardhat");

async function main() {
    const CrdFund = await ethers.getContractFactory("crdfund");
    const crdfund = await CrdFund.deploy();
    await crdfund.deployed();

    console.log(`Contract deployed to: ${crdfund.address}`);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
