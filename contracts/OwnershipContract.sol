// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./AuthenticationContract.sol"; // Assuming the AuthenticationContract is in the same directory

/**
 * @title OwnershipContract
 * @dev Tracks ownership of authenticated items, facilitating the transfer of ownership and ensuring transparency.
 * Integrates with AuthenticationContract to ensure that only authenticated items are transferable.
 */
contract OwnershipContract is AccessControl {
    // Event declarations
    event OwnershipTransferred(string indexed serialNumber, address indexed previousOwner, address indexed newOwner);

    // Define role for the owner transfer authority
    bytes32 public constant TRANSFER_ROLE = keccak256("TRANSFER_ROLE");

    // Mapping from item serial number to current owner address
    mapping(string => address) private itemOwners;

    // Reference to the AuthenticationContract
    AuthenticationContract private authenticationContract;

    /**
     * @dev Sets the address of the AuthenticationContract and configures roles.
     * @param _authenticationContractAddress address of the deployed AuthenticationContract.
     */
    constructor(address _authenticationContractAddress) {
        authenticationContract = AuthenticationContract(_authenticationContractAddress);
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender); // Grant default admin role to contract deployer
        _setupRole(TRANSFER_ROLE, msg.sender); // Grant transfer role to contract deployer
    }

    /**
     * @dev Registers a new item with an owner, assuming the item is authenticated.
     * @param serialNumber The unique identifier for the item.
     * @param owner The address of the item's initial owner.
     */
    function registerNewItemOwnership(string memory serialNumber, address owner) public onlyRole(TRANSFER_ROLE) {
        require(authenticationContract.isAuthenticated(serialNumber), "Item is not authenticated");
        require(itemOwners[serialNumber] == address(0), "Item ownership already registered");
        itemOwners[serialNumber] = owner;
        emit OwnershipTransferred(serialNumber, address(0), owner);
    }

    /**
     * @dev Transfers ownership of an item to a new owner, if the item is authenticated.
     * Can only be called by an account with the TRANSFER_ROLE.
     * @param serialNumber The unique identifier for the item.
     * @param newOwner The address of the new owner.
     */
    function transferOwnership(string memory serialNumber, address newOwner) public onlyRole(TRANSFER_ROLE) {
        require(authenticationContract.isAuthenticated(serialNumber), "Item is not authenticated");
        address currentOwner = itemOwners[serialNumber];
        require(currentOwner != address(0), "Item ownership not registered");
        require(currentOwner != newOwner, "New owner is already the current owner");

        itemOwners[serialNumber] = newOwner;
        emit OwnershipTransferred(serialNumber, currentOwner, newOwner);
    }

    /**
     * @dev Returns the current owner of an item.
     * @param serialNumber The unique identifier for the item.
     * @return The address of the current owner.
     */
    function getCurrentOwner(string memory serialNumber) public view returns (address) {
        require(itemOwners[serialNumber] != address(0), "Item ownership not registered");
        return itemOwners[serialNumber];
    }
}
