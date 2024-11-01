// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./realEstate.sol"; // Import the real estate contract

contract Escrow is ReentrancyGuard {
    // Addresses of the buyer, seller, and escrow agent
    address public buyer;
    address public seller;
    address public escrowAgent;

    // Real estate token and token ID
    RealEstateTokenized public realEstateToken;
    uint256 public tokenId;

    // Deposit amount in escrow
    uint public depositAmount;

    // Status tracking
    bool public isDepositPaid;
    bool public isPropertyTransferred;

    // Constructor to initialize escrow details
    constructor(
        address _buyer,
        address _seller,
        address _escrowAgent,
        address _realEstateToken,
        uint256 _tokenId,
        uint _depositAmount
    ) {
        buyer = _buyer;
        seller = _seller;
        escrowAgent = _escrowAgent;
        realEstateToken = RealEstateTokenized(_realEstateToken);
        tokenId = _tokenId;
        depositAmount = _depositAmount;
    }

    // Modifier to restrict functions to escrow agent
    modifier onlyEscrowAgent() {
        require(msg.sender == escrowAgent, "Only escrow agent can call this function");
        _;
    }

    // Function for buyer to deposit funds into escrow
    function depositToEscrow() external payable nonReentrant {
        require(msg.sender == buyer, "Only buyer can deposit funds");
        require(msg.value == depositAmount, "Incorrect deposit amount");
        require(!isDepositPaid, "Deposit already paid");

        isDepositPaid = true;
    }

    // Function to release funds to the seller upon property transfer
    function releaseFundsToSeller() external onlyEscrowAgent nonReentrant {
        require(isDepositPaid, "Deposit not yet paid");
        require(realEstateToken.ownerOf(tokenId) == buyer, "Property not yet transferred to buyer");

        isPropertyTransferred = true;
        payable(seller).transfer(depositAmount);
    }

    // Function to refund buyer if transaction fails
    function refundBuyer() external onlyEscrowAgent nonReentrant {
        require(isDepositPaid, "Deposit not yet paid");
        require(!isPropertyTransferred, "Cannot refund, property already transferred");

        isDepositPaid = false;
        payable(buyer).transfer(depositAmount);
    }

    // Transfer property from seller to buyer
    function transferProperty() external onlyEscrowAgent nonReentrant {
        require(isDepositPaid, "Deposit not yet paid");
        require(realEstateToken.ownerOf(tokenId) == seller, "Seller must own the property");

        // Transfer the property token from seller to buyer
        realEstateToken.transferProperty(buyer);

        // Set transfer status to complete
        isPropertyTransferred = true;
    }
}
