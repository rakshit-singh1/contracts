/** @type import('hardhat/config').HardhatUserConfig */
require("@nomiclabs/hardhat-waffle")

// const ALCHEMY_API_KEY = "vuwMJpkJvANVxcE-8c4Am-hmrVCdVimi";
const SEPOLIA_API_KEY = "d49d737f92f3383694c3951a7d209ea6725f3c29963810cfc23cd4fa8a4b6724";
const url_infura="https://sepolia.infura.io/v3/9ca1af07007a4463b2a3a3bacb7cafc6";
const url_alchemy="https://eth-sepolia.g.alchemy.com/v2/qK4rlQzMbqWihJaTQcELJxsZovKSCd5u";
module.exports = {
  solidity: "0.8.19",

  networks:{
    sepolia:{
      url:url_alchemy,
      accounts:[`${SEPOLIA_API_KEY}`],
    }
  }
};
