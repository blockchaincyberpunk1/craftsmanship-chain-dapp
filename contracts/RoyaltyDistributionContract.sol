// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./PaymentSplitter.sol";

/**
 * @title RoyaltyDistributionContract
 * @dev Manages the distribution of royalties to creators or manufacturers based on the resale of items.
 * Supports setting royalty percentages, tracking sales, and distributing funds accordingly.
 */
contract RoyaltyDistributionContract is AccessControl, PaymentSplitter {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    struct RoyaltyInfo {
        address recipient;
        uint256 percentage; // Royalty percentage times 100 for precision (e.g., 5% is represented as 500)
    }

    // Mapping from item identifiers to their respective royalty information
    mapping(string => RoyaltyInfo) private itemRoyalties;

    event RoyaltySet(string indexed itemIdentifier, address indexed recipient, uint256 percentage);

    /**
     * @dev Constructor that sets up the default admin role.
     */
    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ADMIN_ROLE, msg.sender);
    }

    /**
     * @notice Sets the royalty information for a specific item.
     * @param itemIdentifier The unique identifier for the item.
     * @param recipient The address of the royalty recipient.
     * @param percentage The percentage of the sale price to be paid as royalty.
     */
    function setRoyaltyInfo(string memory itemIdentifier, address recipient, uint256 percentage) public onlyRole(ADMIN_ROLE) {
        require(percentage <= 10000, "Royalty percentage cannot exceed 100% (10000)");
        itemRoyalties[itemIdentifier] = RoyaltyInfo(recipient, percentage);
        emit RoyaltySet(itemIdentifier, recipient, percentage);
    }

    /**
     * @notice Distributes the royalty for a specific item sale.
     * @param itemIdentifier The unique identifier for the item.
     * @param saleAmount The total amount of the sale.
     */
    function distributeRoyalty(string memory itemIdentifier, uint256 saleAmount) public onlyRole(ADMIN_ROLE) {
        RoyaltyInfo memory info = itemRoyalties[itemIdentifier];
        require(info.recipient != address(0), "Royalty info not set for this item");
        uint256 royaltyAmount = (saleAmount * info.percentage) / 10000;
        _sendPayment(info.recipient, royaltyAmount);
    }

    /**
     * @dev Internal function to send payment to a recipient. Could integrate with PaymentSplitter or directly transfer funds.
     * @param recipient The address receiving the payment.
     * @param amount The amount of funds to send.
     */
    function _sendPayment(address recipient, uint256 amount) internal {
        payable(recipient).transfer(amount);
    }

    // Additional functions such as updating or removing royalty info could be implemented as needed.
}
