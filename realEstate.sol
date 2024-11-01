// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract RealEstateTokenized is ERC721URIStorage, Ownable, ReentrancyGuard {
    // Basic Property Information
    string public propertyAddress;
    string public legalDescription;
    string public buyerName;
    string public sellerName;

    // Financial Information
    uint public price;
    uint public downPayment;
    bool public isFinanced; // true = loan, false = cash

    // Title and Insurance Information
    bool public clearanceRequirement;
    string public insuranceCompany;

    // Closing Date
    uint public closingDate;

    // Token ID tracker
    uint256 private tokenId;

    // Constructor to initialize the contract and mint the token
    constructor(
        string memory _propertyAddress,
        string memory _legalDescription,
        uint _price,
        uint _downPayment,
        bool _isFinanced
        
        
    ) ERC721("RealEstateToken", "RET") Ownable(msg.sender) {
        // Set the property and financial details
        propertyAddress = _propertyAddress;
        legalDescription = _legalDescription;
        price = _price;
        downPayment = _downPayment;
        isFinanced = _isFinanced;
        

        // Mint the token to the contract creator (or specify a different address)
        tokenId = 1; // Starting ID for this property token
        _mint(msg.sender, tokenId); // Minting token to the contract creator (owner)
        
    }

    // Update buyer or seller name if necessary (Only owner can update)
    function setBuyerName(string memory _newBuyerName) public onlyOwner {
        buyerName = _newBuyerName;
    }

    function setSellerName(string memory _newSellerName) public onlyOwner {
        sellerName = _newSellerName;
    }

    // Transfer ownership of the token (property) to a new owner
    function transferProperty(address newOwner) public onlyOwner nonReentrant {
        _transfer(owner(), newOwner, tokenId); // Transfers token ownership
    }
} 