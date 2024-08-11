// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {GamingNFt, InsufficientETH} from "../src/gamingnft.sol";
import {DeployGamingNFt} from "../script/deploy.s.sol";
import {Interactions} from "../script/interactions.s.sol";
import {Test, console2} from "forge-std/Test.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";



contract GamingNFtTest is Test {
    GamingNFt private gamingNFT;
    address private owner = address(this);
    address private user = address(0x1234567890);

    uint256 private initialMintPrice = 0.00001 ether;
    uint256 private initialBatchMintPrice = 0.00005 ether;


    function setUp() public {
        gamingNFT = new GamingNFt(owner);
       
    }
    //Test to ensure the setURI Function
     function testSetURI() public {
        string memory newURI = "https://new-uri.com/{id}.json";

        // Set the URI as the owner
        gamingNFT.setURI(newURI);

        // Verify the URI is set correctly
        string memory actualURI = gamingNFT.uri(1);
        assertEq(actualURI, newURI);
    }

    // Test to ensure an error is thrown when setting the same URI
    function testSetSameURIReverts() public {
        string memory newURI = "https://new-uri.com/{id}.json";

        // Set the URI initially
        gamingNFT.setURI(newURI);

        // Attempt to set the same URI again, expecting a revert with the correct error message
        vm.expectRevert(bytes4(keccak256("NewURIEqualToExistingURI()")));
        gamingNFT.setURI(newURI);

        // Check if the URI is still the same after the failed attempt
        string memory actualURI = gamingNFT.uri(1);
        assertEq(actualURI, newURI);
    }
    function testSuccessfulSingleMint() public {
    // Define the recipient, token ID, amount, and data for minting
    address recipient = user;
    uint256 tokenId = 1;
    uint256 amount = 1;
    bytes memory data = "";

    // Calculate the expected amount of ETH to be sent with the transaction
    uint256 expectedEthSent = initialMintPrice;

    // Execute the mint function with the calculated ETH amount
    gamingNFT.mint{value: expectedEthSent}(recipient, tokenId, amount, data);

    // Assert that the balance of the recipient has increased
    assertEq(gamingNFT.balanceOf(recipient, tokenId), amount, "Balance did not increase as expected");
    }

   function testInsufficientETHForSingleMint() public {
    // Define the recipient, token ID, amount, and data for minting
    address recipient = user;
    uint256 tokenId = 2;
    uint256 amount = 1;
    bytes memory data = "";

    // Calculate the expected amount of ETH to be sent with the transaction
    uint256 insufficientEthSent = initialMintPrice / 2; // Half of the required amount

    // Expect the transaction to revert due to insufficient ETH
    vm.expectRevert(abi.encodeWithSelector(InsufficientETH.selector, initialMintPrice, insufficientEthSent));
    gamingNFT.mint{value: insufficientEthSent}(recipient, tokenId, amount, data);

    // Assert that the balance of the recipient has not increased (this line won't be reached if revert is successful)
    assertEq(gamingNFT.balanceOf(recipient, tokenId), 0, "Recipient's balance should not increase due to insufficient ETH");
    }

    function testSuccessfulBatchMint() public {
    // Define the recipient, token IDs, amounts, and data for minting
    address recipient = user;
    uint256[] memory tokenIds = new uint256[](2);
    uint256[] memory amounts = new uint256[](2);
    bytes memory data = "";

    // Populate the token IDs and amounts arrays
    tokenIds[0] = 1;
    tokenIds[1] = 2;
    amounts[0] = 1;
    amounts[1] = 1;

    // Calculate the expected amount of ETH to be sent with the transaction
    uint256 expectedEthSent = initialBatchMintPrice;

    // Execute the mintBatch function with the calculated ETH amount
    gamingNFT.mintBatch{value: expectedEthSent}(recipient, tokenIds, amounts, data);

    // Assert that the balance of the recipient has increased for each token
    for (uint256 i = 0; i < tokenIds.length; i++) {
        assertEq(gamingNFT.balanceOf(recipient, tokenIds[i]), amounts[i], "Batch balance did not increase as expected");
        }
    }

    function testInsufficientETHForBatchMint() public {
    // Initialize the recipient, token IDs, and amounts
    address recipient = user;
    uint256[] memory tokenIds = new uint256[](2); // Array of token IDs
    uint256[] memory amounts = new uint256[](2); // Array of amounts
    bytes memory data = "";

    // Assign values to the arrays
    tokenIds[0] = 1;
    tokenIds[1] = 2;
    amounts[0] = 1;
    amounts[1] = 1;

    // Calculate the expected amount of ETH to be sent with the transaction
    uint256 insufficientEthSent = initialBatchMintPrice / 2; // Half of the required amount

    // Expect the transaction to revert due to insufficient ETH
    // Ensure that InsufficientETH is a valid error identifier in your contract
    vm.expectRevert(abi.encodeWithSelector(InsufficientETH.selector, initialBatchMintPrice, insufficientEthSent));
    gamingNFT.mintBatch{value: insufficientEthSent}(recipient, tokenIds, amounts, data);
    }
    
    function testSupplyManagement() public {
        address recipient = user;
        uint256 tokenId = 1;
        uint256 amount = 1;
        bytes memory data = "";

        // Mint a token and check supply
        gamingNFT.mint{value: initialMintPrice}(recipient, tokenId, amount, data);
        assertEq(gamingNFT.totalSupply(tokenId), amount, "Total supply should be equal to the amount minted");

        // Mint another token and check supply
        uint256 additionalAmount = 2;
        gamingNFT.mint{value: initialMintPrice * additionalAmount}(recipient, tokenId, additionalAmount, data);
        assertEq(gamingNFT.totalSupply(tokenId), amount + additionalAmount, "Total supply should be updated to include additional minted tokens");

        // Batch mint and check supply
        uint256[] memory tokenIds = new uint256[](2);
        uint256[] memory amounts = new uint256[](2);
        tokenIds[0] = tokenId;
        tokenIds[1] = 2;
        amounts[0] = 3;
        amounts[1] = 4;

        gamingNFT.mintBatch{value: initialBatchMintPrice}(recipient, tokenIds, amounts, data);

        // Check supply for each token ID
        assertEq(gamingNFT.totalSupply(tokenIds[0]), amount + additionalAmount + amounts[0], "Total supply for tokenId 1 should be updated after batch mint");
        assertEq(gamingNFT.totalSupply(tokenIds[1]), amounts[1], "Total supply for tokenId 2 should be equal to the amount minted in batch");
    }

    
}
