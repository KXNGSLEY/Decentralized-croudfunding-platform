const { ethers } = require("hardhat");

async function main() {
    const contractAddress = "YOUR_DEPLOYED_CONTRACT_ADDRESS"; // Replace with actual deployed address
    const CrdFund = await ethers.getContractFactory("crdfund");
    const crdfund = await CrdFund.attach(contractAddress);

    console.log("Interacting with contract at:", contractAddress);

    // Example: Create a new crowdfunding campaign
    let tx = await crdfund.createCampaign(ethers.utils.parseEther("1"), 604800); // 1 ETH goal, 7 days duration
    await tx.wait();
    console.log("Campaign created!");

    // Example: Contribute to campaign 0
    tx = await crdfund.contribute(0, { value: ethers.utils.parseEther("0.1") });
    await tx.wait();
    console.log("Contributed 0.1 ETH to campaign 0!");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
