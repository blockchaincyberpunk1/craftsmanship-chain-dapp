// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title AuthenticationContract
 * @dev Manages the registration, update, and verification of craftsmanship and materials used in luxury goods.
 * Utilizes OpenZeppelin's AccessControl for role-based permissions to ensure that certain actions can only be
 * performed by authenticated users with specific roles.
 */
contract AuthenticationContract is AccessControl {
    // Role definition for the admin and verifier roles
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant VERIFIER_ROLE = keccak256("VERIFIER_ROLE");

    // Custom struct to hold item details and authentication status
    struct Item {
        string name;
        string description;
        bool isAuthenticated;
    }

    // Mapping from item serial number to item details
    mapping(string => Item) private items;

    // Event declarations for logging activities
    event ItemRegistered(string serialNumber, string name);
    event ItemUpdated(string serialNumber, string name);
    event ItemAuthenticated(string serialNumber, bool status);

    /**
     * @dev Constructor to set up roles and grant admin role to the contract deployer.
     */
    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ADMIN_ROLE, msg.sender);
        _setRoleAdmin(VERIFIER_ROLE, ADMIN_ROLE);
    }

    /**
     * @dev Registers a new item with its details.
     * Access is restricted to users with the admin role.
     * @param serialNumber Unique identifier for the item.
     * @param name Name of the item.
     * @param description Description of the item.
     */
    function registerItem(string memory serialNumber, string memory name, string memory description) public onlyRole(ADMIN_ROLE) {
        require(bytes(items[serialNumber].name).length == 0, "Item already registered");
        items[serialNumber] = Item(name, description, false);
        emit ItemRegistered(serialNumber, name);
    }

    /**
     * @dev Updates the details of an existing item.
     * Access is restricted to users with the admin role.
     * @param serialNumber Unique identifier for the item.
     * @param name New name of the item.
     * @param description New description of the item.
     */
    function updateItemDetails(string memory serialNumber, string memory name, string memory description) public onlyRole(ADMIN_ROLE) {
        require(bytes(items[serialNumber].name).length > 0, "Item not registered");
        items[serialNumber].name = name;
        items[serialNumber].description = description;
        emit ItemUpdated(serialNumber, name);
    }

    /**
     * @dev Marks an item as authenticated or not.
     * Access is restricted to users with the verifier role.
     * @param serialNumber Unique identifier for the item.
     * @param isAuthenticated Authentication status to be set.
     */
    function authenticateItem(string memory serialNumber, bool isAuthenticated) public onlyRole(VERIFIER_ROLE) {
        require(bytes(items[serialNumber].name).length > 0, "Item not registered");
        items[serialNumber].isAuthenticated = isAuthenticated;
        emit ItemAuthenticated(serialNumber, isAuthenticated);
    }

    /**
     * @dev Retrieves item details and authentication status.
     * Can be accessed by any user.
     * @param serialNumber Unique identifier for the item.
     * @return Item details including name, description, and authentication status.
     */
    function getItemDetails(string memory serialNumber) public view returns (Item memory) {
        require(bytes(items[serialNumber].name).length > 0, "Item not registered");
        return items[serialNumber];
    }
}
