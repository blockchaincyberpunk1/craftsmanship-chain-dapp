// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title IPFSIntegrationContract
 * @dev Integrates blockchain functionality with IPFS for storing and retrieving large data files, such as images or certificates of authenticity.
 * Stores IPFS hashes on-chain as references to the off-chain data.
 */
contract IPFSIntegrationContract is AccessControl {
    bytes32 public constant DATA_UPLOADER_ROLE = keccak256("DATA_UPLOADER_ROLE");

    // Mapping from an item's unique identifier to its IPFS hash
    mapping(string => string) private itemIPFSHashes;

    // Event to log the addition of a new IPFS hash for an item
    event IPFSHashAdded(string indexed itemIdentifier, string ipfsHash);

    /**
     * @dev Constructor that sets up the default admin role and grants DATA_UPLOADER_ROLE to the contract deployer.
     */
    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(DATA_UPLOADER_ROLE, msg.sender);
    }

    /**
     * @notice Adds a new IPFS hash for an item.
     * @dev Stores the IPFS hash for a given item identifier. Only callable by accounts with DATA_UPLOADER_ROLE.
     * @param itemIdentifier A unique identifier for the item.
     * @param ipfsHash The IPFS hash of the item's data.
     */
    function addIPFSHash(string memory itemIdentifier, string memory ipfsHash) public onlyRole(DATA_UPLOADER_ROLE) {
        require(bytes(itemIPFSHashes[itemIdentifier]).length == 0, "IPFS hash already set for this item");
        itemIPFSHashes[itemIdentifier] = ipfsHash;
        emit IPFSHashAdded(itemIdentifier, ipfsHash);
    }

    /**
     * @notice Retrieves the IPFS hash for an item.
     * @dev Returns the stored IPFS hash for a given item identifier.
     * @param itemIdentifier A unique identifier for the item.
     * @return The IPFS hash of the item's data.
     */
    function getIPFSHash(string memory itemIdentifier) public view returns (string memory) {
        require(bytes(itemIPFSHashes[itemIdentifier]).length != 0, "No IPFS hash set for this item");
        return itemIPFSHashes[itemIdentifier];
    }
}
