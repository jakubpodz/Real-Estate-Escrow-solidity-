const Web3 = require('web3');

require('dotenv').config();
const infuraProjectId = process.env.INFURA_PROJECT_ID;

const web3 = new Web3(new Web3.providers.HttpProvider(`https://ropsten.infura.io/v3/${INFURA_PROJECT_ID}`));

// Contract ABIs and Addresses
const escrowABI = require('./escrowABI.json');
const realEstateABI = require('./realEstateABI.json');
const escrowAddress = 'YOUR_ESCROW_CONTRACT_ADDRESS';
const realEstateAddress = 'YOUR_REAL_ESTATE_CONTRACT_ADDRESS';

// Contract instances
const escrowContract = new web3.eth.Contract(escrowABI, escrowAddress);
const realEstateContract = new web3.eth.Contract(realEstateABI, realEstateAddress);

// MetaMask integration
if (typeof window.ethereum !== 'undefined') {
    console.log('MetaMask is installed!');
} else {
    console.error('Please install MetaMask!');
}

async function connectMetaMask() {
    try {
        await window.ethereum.request({ method: 'eth_requestAccounts' });
        web3.setProvider(window.ethereum); // Use MetaMask as Web3 provider
        const accounts = await web3.eth.getAccounts();
        return accounts[0];
    } catch (error) {
        console.error("MetaMask connection error:", error);
        return null;
    }
}


async function deposit(amount) {
    const account = await connectMetaMask();
    await escrowContract.methods.deposit().send({ from: account, value: web3.utils.toWei(amount, 'ether') });
    console.log(`Deposited ${amount} ETH`);
}

async function releaseFunds() {
    const account = await connectMetaMask();
    await escrowContract.methods.release().send({ from: account });
    console.log('Funds Released');
}

async function refund() {
    const account = await connectMetaMask();
    await escrowContract.methods.refund().send({ from: account });
    console.log('Refunded');
}


async function transferProperty(newOwnerAddress) {
    const account = await connectMetaMask();
    await realEstateContract.methods.transferProperty(newOwnerAddress).send({ from: account });
    console.log(`Property transferred to ${newOwnerAddress}`);
}

async function getPropertyOwner() {
    const owner = await realEstateContract.methods.owner().call();
    console.log(`Current Property Owner: ${owner}`);
    return owner;
}

(async () => {
    try {
        
        const currentOwner = await getPropertyOwner();
        console.log(`Current owner of the property: ${currentOwner}`);
        
        //Values for testing:
        const depositAmount = "0.5"; 
        const newOwnerAddress = "0xNewOwnerAddressHere"; 

        
        
        await deposit(depositAmount); 
        await releaseFunds(); 
        await refund(); 
        await transferProperty(newOwnerAddress); 
        
    } catch (error) {
        console.error("Error executing script:", error);
    }
})();
