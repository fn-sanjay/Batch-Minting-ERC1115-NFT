// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {GamingNFt} from "../src/gamingnft.sol";

contract Interactions is Script {
    function run() external {
    // Start broadcasting transactions
    vm.startBroadcast();

    // Retrieve the most recently deployed GamingNFt contract
    address gamingNFTAddress = DevOpsTools.get_most_recent_deployment("GamingNFt", block.chainid);
    GamingNFt gamingNFT = GamingNFt(gamingNFTAddress);

    //Set a new URI for the tokens
    string memory newURI = "https://ipfs.io/ipfs/Qmf5yAF6Gyh9woSPE3xuC9Kyz7pc43bXZA4hn7pzb7bxRm/{id}.json";
    gamingNFT.setURI(newURI);
    console.log("Set new URI to %s", newURI);

    // Mint a single token
    uint256 singleMintId = 4; // Token ID
    uint256 singleMintAmount = 1; // Amount of tokens to mint
    bytes memory data = ""; // Additional data (can be empty)

    gamingNFT.mint{value: 0.00001 ether}(msg.sender, singleMintId, singleMintAmount, data);
    console.log("Minted token ID %s, amount %s to %s", singleMintId, singleMintAmount, msg.sender);

    // Mint a batch of tokens
    uint256[] memory batchIds = new uint256[](5); // Declare batchIds as a dynamic array of uint256
    uint256[] memory batchAmounts = new uint256[](5); // Declare batchAmounts as a dynamic array of uint256

    batchIds[0] = 0;
    batchIds[1] = 1;
    batchIds[2] = 2;
    batchIds[3] = 3;
    batchIds[4] = 5;
    

    batchAmounts[0] = 100;
    batchAmounts[1] = 50;
    batchAmounts[2] = 25;
    batchAmounts[3] = 10;
    batchAmounts[4] = 5;
    

    uint256 requiredETH = 0.00005 ether; // This should match requiredETHForBatchMint in the contract
    gamingNFT.mintBatch{value: requiredETH}(msg.sender, batchIds, batchAmounts, data);
    console.log("Minted batch of token IDs to %s", msg.sender);

    // End broadcasting transactions
    vm.stopBroadcast();
}

}
