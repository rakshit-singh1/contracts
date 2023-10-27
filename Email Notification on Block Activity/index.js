const { ethers, JsonRpcProvider ,formatEther} = require('ethers');
const YOUR_INFURA_PROJECT_ID = '9ca1af07007a4463b2a3a3bacb7cafc6';
const { sendMail } =require('./sendMail')
const provider = new JsonRpcProvider(`https://sepolia.infura.io/v3/${YOUR_INFURA_PROJECT_ID}`);

const contractAddress = '0x2e777c5b0052d933500eAD5BD34ba995Deb6BfF2';

provider.on('block', async (blockNumber) => {
    try {
        const block = await provider.getBlock(blockNumber);
        //console.log(block)
        if (block && block.transactions) {
            for (const txHash of block.transactions) {
                const tx = await provider.getTransaction(txHash);

                if (tx && tx.to === contractAddress) {
                    console.log(tx);
                    const from = tx.from;
                    const amount = formatEther(tx.value);
                    sendMail(tx.hash,from,amount)
                    console.log(`A transaction completed from ${ from } of amount ${ amount }`);
                }
            }
        }
    } catch (error) {
        console.error('Error processing block:', error);
    }
});

// TPO: 8146616791