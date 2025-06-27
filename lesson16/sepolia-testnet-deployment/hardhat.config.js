require('dotenv').config();
require("@nomiclabs/hardhat-ethers");

const {RPC_ENDPOINT_URL, PRIVATE_KEY} = process.env
module.exports = {
  solidity: "0.8.28",
  defaultNetwork: "sepolia",
  networks: {
    hardhat: {},
    sepolia: {
      url: RPC_ENDPOINT_URL,
      accounts: [`0x${PRIVATE_KEY}`]
    }
  },
};
