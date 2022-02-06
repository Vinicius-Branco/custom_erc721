require("dotenv").config();
require("hardhat-deploy");
require("@nomiclabs/hardhat-waffle");
require("@openzeppelin/hardhat-upgrades");
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");

const { PRIVATE_KEY, BSCSCAN_API_KEY } = process.env;

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    version: "0.8.2",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    localhost: {
      url: "http://localhost:8545",
    },
    bsc: {
      url: "https://bsc-dataseed1.binance.org:443",
      accounts: [`${PRIVATE_KEY}`],
    },
    etherscan: {
      url: "https://api.bscscan.com",
      apiKey: BSCSCAN_API_KEY,
    },
    bsctestnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
      accounts: [`${PRIVATE_KEY}`],
    },
  },
  etherscan: {
    url: "https://api.bscscan.com",
    apiKey: { bsc: BSCSCAN_API_KEY },
  },
};
