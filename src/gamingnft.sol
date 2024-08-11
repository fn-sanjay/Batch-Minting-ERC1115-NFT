// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
//Imports

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC1155Supply} from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

// Custom Errors
error InsufficientETH(uint256 required, uint256 sent);
error NewURIEqualToExistingURI();

contract GamingNFt is ERC1155, Ownable, ERC1155Supply {
    // State varibales
    string private _uri;
    uint256 public requiredETHForMint = 0.00001 ether;
    uint256 public requiredETHForBatchMint = 0.00005 ether;

    constructor(address initialOwner) ERC1155("") Ownable(initialOwner) {}

    // Function to set a URI
    function setURI(string memory uri) public onlyOwner {
        string memory currentURI = _uri;
        if (keccak256(abi.encodePacked(currentURI)) == keccak256(abi.encodePacked(uri))) {
            revert NewURIEqualToExistingURI();
        }
        _uri = uri;
        _setURI(uri);
    }

    // Function to set required ETH for minting a single token
    function setRequiredETHForMint(uint256 newRequiredETH) public onlyOwner {
        requiredETHForMint = newRequiredETH;
    }

    // Function to set required ETH for batch minting
    function setRequiredETHForBatchMint(uint256 newRequiredETH) public onlyOwner {
        requiredETHForBatchMint = newRequiredETH;
    }

    // Function to mint a single token
    function mint(address account, uint256 id, uint256 amount, bytes memory data) public payable onlyOwner {
        if (msg.value < requiredETHForMint) {
            revert InsufficientETH(requiredETHForMint, msg.value);
        }
        _mint(account, id, amount, data);
    }

    // Function to mint multiple tokens in a batch
    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        payable
        onlyOwner
    {
        if (msg.value < requiredETHForBatchMint) {
            revert InsufficientETH(requiredETHForBatchMint, msg.value);
        }
        _mintBatch(to, ids, amounts, data);
    }

    // Override _update function to be compatible with ERC1155Supply
    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._update(from, to, ids, values);
    }
}
