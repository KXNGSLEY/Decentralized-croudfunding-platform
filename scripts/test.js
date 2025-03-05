const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("crdfund Contract", function () {
    let crdfund, owner, addr1, addr2;

    beforeEach(async function () {
        const CrdFund = await ethers.getContractFactory("crdfund");
        [owner, addr1, addr2] = await ethers.getSigners();
        crdfund = await CrdFund.deploy();
        await crdfund.deployed();
    });

    it("Should create a new campaign", async function () {
        await crdfund.createCampaign(ethers.utils.parseEther("1"), 604800);
        const campaign = await crdfund.campaigns(0);
        expect(campaign.goal).to.equal(ethers.utils.parseEther("1"));
    });

    it("Should allow contributions", async function () {
        await crdfund.createCampaign(ethers.utils.parseEther("1"), 604800);
        await crdfund.connect(addr1).contribute(0, { value: ethers.utils.parseEther("0.5") });
        const campaign = await crdfund.campaigns(0);
        expect(campaign.fundsRaised).to.equal(ethers.utils.parseEther("0.5"));
    });

    it("Should allow the campaign owner to withdraw funds", async function () {
        await crdfund.createCampaign(ethers.utils.parseEther("1"), 1);
        await ethers.provider.send("evm_increaseTime", [2]); // Fast-forward time
        await crdfund.withdrawFunds(0);
        expect((await ethers.provider.getBalance(crdfund.address))).to.equal(0);
    });
});
