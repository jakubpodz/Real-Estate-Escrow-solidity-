---

# Real Estate Escrow Smart Contracts

This project includes smart contracts and a JavaScript Web3.js integration to facilitate secure escrow transactions for real estate tokenization on the Ethereum blockchain. The solution enables buyers, sellers, and escrow agents to interact with real estate properties represented as digital tokens.

## Project Structure

- **`escrow.sol`**: Smart contract for escrow functionality, handling deposits, refunds, and fund releases between buyers and sellers.
- **`realEstate.sol`**: Smart contract for real estate tokenization, allowing property transfers and ownership management.
- **`escrowABI.json`**: ABI file for the `escrow.sol` contract.
- **`realEstateABI.json`**: ABI file for the `realEstate.sol` contract.
- **`web3.js`**: JavaScript file for interacting with the Ethereum blockchain, utilizing Infura and MetaMask to manage transactions.

## Getting Started

### Prerequisites

- Node.js and npm
- MetaMask browser extension
- Infura account (for Ethereum node access)

### Installation

1. Clone this repository.
    ```bash
    git clone https://github.com/your-username/your-repo.git
    cd your-repo
    ```

2. Install the necessary npm packages:
    ```bash
    npm install web3 dotenv
    ```

3. Set up Infura:
   - Create a `.env` file with your Infura Project ID:
     ```
     INFURA_PROJECT_ID=your-infura-project-id
     ```

4. MetaMask:
   - Make sure MetaMask is installed and connected to the Ethereum Ropsten test network or another network compatible with Infura.

### Deploying Contracts

The contracts can be deployed using Remix or Hardhat. Once deployed, replace the contract addresses in `web3.js` as follows:

```javascript
const escrowAddress = 'YOUR_ESCROW_CONTRACT_ADDRESS';
const realEstateAddress = 'YOUR_REAL_ESTATE_CONTRACT_ADDRESS';
```

### Usage

#### Connecting with MetaMask

The `web3.js` script checks for MetaMask installation and connects to it when required. Ensure your MetaMask wallet is unlocked.

#### Key Functions

- **Deposit Funds**:
  ```javascript
  async function deposit(amount) {
      await escrowContract.methods.deposit().send({ from: account, value: web3.utils.toWei(amount, 'ether') });
  }
  ```

- **Release Funds**:
  ```javascript
  async function releaseFunds() {
      await escrowContract.methods.release().send({ from: account });
  }
  ```

- **Refund Buyer**:
  ```javascript
  async function refund() {
      await escrowContract.methods.refund().send({ from: account });
  }
  ```

- **Transfer Property**:
  ```javascript
  async function transferProperty(newOwnerAddress) {
      await realEstateContract.methods.transferProperty(newOwnerAddress).send({ from: account });
  }
  ```

#### Example Usage

Example calls are already provided in the `web3.js` file:

```javascript
(async () => {
    const depositAmount = "0.5"; 
    const newOwnerAddress = "0xNewOwnerAddressHere"; 
    await deposit(depositAmount); 
    await releaseFunds(); 
    await refund(); 
    await transferProperty(newOwnerAddress); 
})();
```

### Contract ABI Details

For more details, refer to `escrowABI.json` and `realEstateABI.json`, which outline the contract methods and event structures.

## License

This project is licensed under the MIT License.

---



