// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title ReviewAndRatingContract
 * @dev Manages reviews and ratings for items, allowing for feedback on authenticity and quality to build trust and transparency in the ecosystem.
 */
contract ReviewAndRatingContract is AccessControl {
    struct Review {
        address reviewer;
        uint8 rating; // Rating on a scale of 1 to 5
        string comment;
        uint256 timestamp;
    }

    // Mapping from item identifiers to lists of reviews
    mapping(string => Review[]) private itemReviews;

    bytes32 public constant REVIEWER_ROLE = keccak256("REVIEWER_ROLE");

    event ReviewAdded(string indexed itemIdentifier, address indexed reviewer, uint8 rating, string comment);

    /**
     * @dev Sets up the default admin role.
     */
    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /**
     * @notice Adds a review for an item.
     * @param itemIdentifier The unique identifier for the item being reviewed.
     * @param rating The rating given to the item, from 1 to 5.
     * @param comment A text comment about the item.
     */
    function addReview(string memory itemIdentifier, uint8 rating, string memory comment) public onlyRole(REVIEWER_ROLE) {
        require(rating >= 1 && rating <= 5, "Invalid rating: must be between 1 and 5");
        itemReviews[itemIdentifier].push(Review({
            reviewer: msg.sender,
            rating: rating,
            comment: comment,
            timestamp: block.timestamp
        }));
        emit ReviewAdded(itemIdentifier, msg.sender, rating, comment);
    }

    /**
     * @notice Retrieves the reviews for an item.
     * @param itemIdentifier The unique identifier for the item.
     * @return An array of reviews for the specified item.
     */
    function getReviews(string memory itemIdentifier) public view returns (Review[] memory) {
        return itemReviews[itemIdentifier];
    }

    /**
     * @notice Calculates the average rating for an item.
     * @param itemIdentifier The unique identifier for the item.
     * @return The average rating for the specified item.
     */
    function calculateAverageRating(string memory itemIdentifier) public view returns (uint8) {
        Review[] memory reviews = itemReviews[itemIdentifier];
        uint256 totalRating = 0;
        for (uint256 i = 0; i < reviews.length; i++) {
            totalRating += reviews[i].rating;
        }
        return reviews.length > 0 ? uint8(totalRating / reviews.length) : 0;
    }

    /**
     * @dev Grants REVIEWER_ROLE to a user, enabling them to submit reviews.
     * Can only be called by an account with the DEFAULT_ADMIN_ROLE.
     * @param reviewer The address of the user to grant review privileges.
     */
    function grantReviewerRole(address reviewer) public onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(REVIEWER_ROLE, reviewer);
    }
}
