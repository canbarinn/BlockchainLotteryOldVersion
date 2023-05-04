import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import { task } from "hardhat/config";
import { ethers } from "ethers";
import "hardhat-gas-reporter";

const config: HardhatUserConfig = {
  solidity: "0.8.18",
  gasReporter: {
    enabled: true
  },
  networks: {
    hardhat: {
      accounts: {
        count: 300,
      },
      
    },
  },
};

export default config;
