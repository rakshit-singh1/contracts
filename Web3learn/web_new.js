const solc = require("solc");

// file system - read and write files to your computer
const fs = require("fs");

// ganache - local blockchain

// web3 interface
const {Web3} = require("web3");

//import .env variables
require("dotenv").config();

// setup a http provider
const network = process.env.ETHEREUM_NETWORK;
const web3 = new Web3(new Web3.providers.HttpProvider(`https://${network}.infura.io/v3/${process.env.INFURA_API_KEY}`));

// reading the file contents of the smart  contract

fileContent = fs.readFileSync("demo.sol").toString();
console.log(fileContent);

// create an input structure for my solidity complier
var input = {
  language: "Solidity",
  sources: {
    "demo.sol": {
      content: fileContent,
    },
  },

  settings: {
    outputSelection: {
      "*": {
        "*": ["*"],
      },
    },
  },
};

var output = JSON.parse(solc.compile(JSON.stringify(input)));
console.log("Output: ", output);

const ABI = output.contracts["demo.sol"]["demo"].abi;
const bytecode = output.contracts["demo.sol"]["demo"].evm.bytecode.object;
console.log("Bytecode: ", bytecode);
console.log("ABI: ", ABI);
console.log("KEY",process.env.INFURA_API_KEY);
const signer = web3.eth.accounts.privateKeyToAccount(
  process.env.SIGNER_PRIVATE_KEY,
);
web3.eth.accounts.wallet.add(signer);

const contract = new web3.eth.Contract(ABI);
// let defaultAccount;
// web3.eth.getAccounts().then((accounts) => {
//   console.log("Accounts:", accounts); //it will show all the accounts

//   defaultAccount = accounts[0];
//   console.log("Default Account:", defaultAccount);  //to deploy the contract from default Account

// });
  //console.log("Contract:\n", contract,"\n");  //to chech the deployment of contract
contract
.deploy({ 
  data: bytecode
})
.send({ 
  from: signer.address, 
  gas: 470000,
})
.on("receipt", (receipt) => { //event,transactions,contract address will be returned by blockchain
  console.log("Contract Address:", receipt.contractAddress);
})
.then((demoContract) => {
  const res = demoContract.methods.x().call();
  res.then(data => {
    console.log("Initial value:", data,"\nDone!");
  });
});