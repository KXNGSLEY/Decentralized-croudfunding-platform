# Crowdfunding NFT Smart Contract 🚀  

## 📜 Overview  
This Solidity smart contract enables **decentralized crowdfunding** with **NFT rewards** for backers.  
- Supports multiple crowdfunding campaigns  
- Rewards backers with **unique NFTs** upon successful funding  
- Implements **ReentrancyGuard** for security  
- Uses **ERC721URIStorage** for NFT metadata management  

## ⚙️ Features  
✅ **Create Campaigns** – Project owners can create fundraising campaigns with funding goals and deadlines.  
✅ **Pledge Funds** – Users can contribute to campaigns and receive NFTs as rewards.  
✅ **Withdraw Funds** – Funds are only released if the campaign meets its funding goal.  
✅ **Refund Mechanism** – If a campaign fails, backers can claim refunds.  
✅ **Secure & Efficient** – Uses OpenZeppelin's **Ownable, ReentrancyGuard, and ERC721** standards.  

## 🔧 Installation & Deployment  


## 📦 Dependencies  
This project uses the following dependencies for secure and efficient smart contract development:  

| Dependency                     | Purpose |
|--------------------------------|---------|
| [**Solidity (0.8.x)**](https://soliditylang.org/) | Smart contract programming language |
| [**OpenZeppelin Contracts**](https://github.com/OpenZeppelin/openzeppelin-contracts) | Secure, audited smart contract templates (ERC721, Ownable, ReentrancyGuard) |
| [**Hardhat**](https://hardhat.org/) | Smart contract development & testing framework |
| [**Ethers.js**](https://docs.ethers.org/) | Library for interacting with Ethereum blockchain |
| [**dotenv**](https://www.npmjs.com/package/dotenv) | Loads environment variables securely (e.g., private keys) |

### 🔧 **Installation**  
Run the following command to install all dependencies:  
```bash
npm install @openzeppelin/contracts hardhat ethers dotenv

### **hh**
