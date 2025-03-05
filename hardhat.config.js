module.exports = {
    solidity: "0.8.20",
    paths: {
        sources: "./contracts", 
    },
    networks: {
        goerli: {
            url: "YOUR_INFURA_ALCHEMY_RPC_URL",
            accounts: ["YOUR_PRIVATE_KEY"]
        }
    }
};
