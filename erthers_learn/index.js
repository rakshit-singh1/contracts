const express = require('express');
const { ethers, JsonRpcProvider ,parseEther, parseUnits, formatEther, formatUnits, keccak256, sha256, toUtf8Bytes } = require('ethers');
const bodyParser = require('body-parser');
//console.log(ethers);
const router = express();
router.use(bodyParser.json());
const dotenv = require('dotenv');
require('dotenv').config();
const senderAddress = '0x668425484835D082D11e3A83b97D47705Ef6ACA4'
//const provider = new ethers.providers.JsonRpcProvider("https://sepolia.infura.io/v3/9ca1af07007a4463b2a3a3bacb7cafc6");
const provider = new JsonRpcProvider("https://sepolia.infura.io/v3/9ca1af07007a4463b2a3a3bacb7cafc6");
router.post('/getBalance', async (req, res) => {
    try {
        let balance = await provider.getBalance("0x668425484835D082D11e3A83b97D47705Ef6ACA4");
        balance = formatEther(balance.toString())
        res.status(200).json({ success: true, message: `Balance is ${balance}` });
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ success: false, message: 'Error getting balance.' });
    }
});
router.post('/convertions', async (req, res) => {
    try {
        const eth = parseEther("1.0")// Convert user-provided strings in ether to wei for a value
        const feePerGas = parseUnits("4.5", "gwei")
        const wei=formatEther(eth)// Convert a value in wei to a string in ether to display in a UI
        const gwei=formatUnits(feePerGas, "gwei")
        res.status(200).json({ success: true, message: `${wei.toString()} ether = ${eth.toString()} wei and ${gwei.toString()} gwei = ${feePerGas.toString()} eth` });
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ success: false, message: 'Error getting balance.' });
    }
});
router.post('/GenerateAccount', (req, res) => {
    try {
        const wallet = ethers.Wallet.createRandom();
        res.json({address: wallet.address,privateKey: wallet.privateKey,});
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});
router.post('/SendTransaction', async (req, res) => {
    try {
        const key = process.env.SIGNER_PRIVATE_KEY;
        const { recipientAddress, amountInEther } = req.body;
        const wallet = new ethers.Wallet(key, provider);
        const valueInWei = parseEther(amountInEther).toString();
        const tx = await wallet.sendTransaction({ to: recipientAddress, value: valueInWei, });
        await tx.wait();

        res.json({ transactionHash: tx.hash });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});
router.post('/Encode', async (req, res) => {
    try {
        let {data} = req.body;
        console.log(data)
        data=toUtf8Bytes(data);
        
        console.log(keccak256);
        const keccak = keccak256(data);
        const sha = sha256(data);
        res.status(200).json({ success: true, message: `SHA-256: ${sha} and Keccak-256: ${keccak}`});
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ success: false, message: 'Error encoding' });
    }
});
// solidityPackedKeccak256
// solidityPackedSha256
const port = process.env.PORT || 5000;
process.stdout.write('\x1b]2;API Success\x1b\x5c');

router.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
