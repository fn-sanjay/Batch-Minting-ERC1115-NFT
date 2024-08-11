# GamingNFT Project

This repository contains the smart contract and deployment scripts for the GamingNFT project. The project utilizes the ERC-1155 token standard and is built using Solidity, Foundry, and OpenZeppelin libraries.

## Prerequisites

- [Foundry](https://getfoundry.sh/) - A fast, portable, and modular toolkit for Ethereum application development.
- An Ethereum node or local blockchain such as [Anvil](https://book.getfoundry.sh/anvil/) for testing and deployment.
- [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts) - For using ERC-1155 standard and other utilities.

## Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd batch-minting-nft
2. Install the dependencies:
    ```bash
    make install
3. Build the Project 
   ```bash
   make build
## Usage

### Testing

- Ensure the integrity and functionality of your smart contracts by running the comprehensive test suite:
   ```bash
   make test
## Deployment

1. To deploy the GamingNFT contract to your local Anvil blockchain:
   ```bash
   make deploy
 > This will deploy the GamingNFT contract with the initial owner address set to 0x8C013D87002b1D6956988B1597FCe68DD39442C5 . Replace this with your actual owner address.
2. Deploy your GamingNFT contract to a local Anvil blockchain for initial testing and verification:
   ```bash
   make deploy ARGS="--network sepolia"
## Interactions
- After deployment, you can interact with the contract using the interactions script:
  ```bash
  make mint
## Makefile Commands
- make clean: Cleans the project by removing build artifacts.
- make remove: Removes submodules and resets the repository.
- make update: Updates project dependencies.
- make install: Installs the necessary dependencies.
- make build: Compiles the smart contracts.
- make test: Runs the test suite.
- make snapshot: Generates a snapshot for test results.
- make format: Formats the code using forge fmt.
- make deploy: Deploys the GamingNFT contract.
- make mint: Runs the interaction script to mint tokens.

## Environment Variables

If you are deploying to the Sepolia network, you need to set up the following environment variables in a `.env` file:

> **Disclaimer**: Do not expose your private key publicly. Instead, consider using secure methods such as `cast wallet import` for managing your private keys.

- `SEPOLIA_RPC_URL`: The RPC URL of the Sepolia network.
- `PRIVATE_KEY`: The private key of the deploying account.
- `ETHERSCAN_API_KEY`: Your Etherscan API key for contract verification.

## License
This project is licensed under the MIT License.




