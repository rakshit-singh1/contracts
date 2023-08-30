// Connection
async function ConnectToWallet() {
    if (typeof ethereum !== 'undefined') {
        const chainId = await ethereum.request({ method: 'eth_chainId' });

        if (chainId === '0xaa36a7') {
            document.getElementById('connect').textContent = "CONNECTION SUCCEEDED!";
        } else {
            alert('Please switch to the Sepolia Mainnet');
        }
    } else {
        alert('MetaMask is not installed');
    }
}

// Balance Display
async function DisplayBalance() {
    const web3 = new Web3(window.ethereum);
    try {
        const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
        const account = accounts[0];
        console.log('Connected to MetaMask with address:', account);

        try {
            const balance = await web3.eth.getBalance(account);
            const balanceEth = web3.utils.fromWei(balance, 'ether');
            document.getElementById('balance').textContent = "YOUR METAMASK WALLET BALANCE: " + balanceEth + " ETHERS";
        } catch (error) {
            alert('Error fetching balance:', error);
        }
    } catch (error) {
        alert('Error connecting to MetaMask:', error);
    }
}