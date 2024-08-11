// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {GamingNFt} from "../src/gamingnft.sol";

contract DeployGamingNFt is Script {
    address initialOwner = 0x8C013D87002b1D6956988B1597FCe68DD39442C5; //Replace with your actual owner address

    function run() external {
        // Start broadcasting from the default account
        vm.startBroadcast();

        // Deploy the contract
        GamingNFt nftContract = new GamingNFt(initialOwner);

        // Stop broadcasting
        vm.stopBroadcast();

        // Print the contract address
        console.log("GamingNFt deployed to:", address(nftContract));
    }
}
