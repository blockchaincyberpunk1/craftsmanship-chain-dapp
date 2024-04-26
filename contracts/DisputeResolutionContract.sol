// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title DisputeResolutionContract
 * @dev Manages dispute resolution related to the authenticity or ownership of items, facilitating arbitration and evidence presentation.
 */
contract DisputeResolutionContract is AccessControl {
    bytes32 public constant ARBITER_ROLE = keccak256("ARBITER_ROLE");

    struct Dispute {
        address initiator;
        string itemIdentifier;
        string reason;
        bool resolved;
        address resolvedBy;
        string resolutionDetails;
    }

    Dispute[] public disputes;

    event DisputeInitiated(uint indexed disputeId, address indexed initiator, string reason);
    event DisputeResolved(uint indexed disputeId, address indexed resolvedBy, string resolutionDetails);

    /**
     * @dev Constructor to set up the default admin role and arbiters.
     */
    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /**
     * @notice Initiates a dispute related to an item's authenticity or ownership.
     * @param itemIdentifier The unique identifier of the item in dispute.
     * @param reason The reason for initiating the dispute.
     */
    function initiateDispute(string memory itemIdentifier, string memory reason) public {
        disputes.push(Dispute({
            initiator: msg.sender,
            itemIdentifier: itemIdentifier,
            reason: reason,
            resolved: false,
            resolvedBy: address(0),
            resolutionDetails: ""
        }));

        emit DisputeInitiated(disputes.length - 1, msg.sender, reason);
    }

    /**
     * @notice Resolves a dispute with details on the resolution.
     * @dev Only accessible by users with the ARBITER_ROLE.
     * @param disputeId The ID of the dispute to resolve.
     * @param resolutionDetails The details of the dispute resolution.
     */
    function resolveDispute(uint disputeId, string memory resolutionDetails) public onlyRole(ARBITER_ROLE) {
        Dispute storage dispute = disputes[disputeId];
        require(!dispute.resolved, "Dispute already resolved");

        dispute.resolved = true;
        dispute.resolvedBy = msg.sender;
        dispute.resolutionDetails = resolutionDetails;

        emit DisputeResolved(disputeId, msg.sender, resolutionDetails);
    }

    /**
     * @notice Grants ARBITER_ROLE to a user, allowing them to resolve disputes.
     * @dev Only accessible by the default admin.
     * @param arbiter The address of the user to grant the arbiter role.
     */
    function grantArbiterRole(address arbiter) public onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(ARBITER_ROLE, arbiter);
    }
}
