// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title MaterialTrackingContract
 * @dev Manages and tracks the materials used in the production of goods, focusing on sustainability and ethical sourcing.
 * Allows manufacturers to log materials, their sources, and certifications. Also, enables users to verify these details.
 */
contract MaterialTrackingContract is AccessControl {
    // Define roles for different actions within the contract
    bytes32 public constant MANUFACTURER_ROLE = keccak256("MANUFACTURER_ROLE");
    bytes32 public constant VERIFIER_ROLE = keccak256("VERIFIER_ROLE");

    // Struct to store material details
    struct Material {
        string name;
        string source;
        string certification;
        bool isVerified;
    }

    // Mapping from item serial number to its materials
    mapping(string => Material[]) private itemMaterials;

    // Events for logging contract activities
    event MaterialLogged(string indexed serialNumber, string materialName, string source);
    event MaterialVerified(string indexed serialNumber, string materialName, bool isVerified);

    /**
     * @dev Constructor that sets up the default admin role and roles for manufacturers and verifiers.
     */
    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MANUFACTURER_ROLE, msg.sender);
        _setupRole(VERIFIER_ROLE, msg.sender);
    }

    /**
     * @dev Allows manufacturers to log new materials for an item.
     * Access is restricted to users with the MANUFACTURER_ROLE.
     * @param serialNumber The unique identifier for the item.
     * @param name The name of the material.
     * @param source The source of the material.
     * @param certification The certification details for the material.
     */
    function logMaterial(string memory serialNumber, string memory name, string memory source, string memory certification) public onlyRole(MANUFACTURER_ROLE) {
        itemMaterials[serialNumber].push(Material(name, source, certification, false));
        emit MaterialLogged(serialNumber, name, source);
    }

    /**
     * @dev Allows verifiers to verify the materials logged for an item.
     * Access is restricted to users with the VERIFIER_ROLE.
     * @param serialNumber The unique identifier for the item.
     * @param materialIndex The index of the material in the item's material array.
     */
    function verifyMaterial(string memory serialNumber, uint materialIndex) public onlyRole(VERIFIER_ROLE) {
        require(materialIndex < itemMaterials[serialNumber].length, "Invalid material index");
        Material storage material = itemMaterials[serialNumber][materialIndex];
        material.isVerified = true;
        emit MaterialVerified(serialNumber, material.name, true);
    }

    /**
     * @dev Retrieves the materials and their verification status for an item.
     * Can be accessed by any user to verify sustainability and ethical sourcing.
     * @param serialNumber The unique identifier for the item.
     * @return The list of materials and their details for the specified item.
     */
    function getItemMaterials(string memory serialNumber) public view returns (Material[] memory) {
        return itemMaterials[serialNumber];
    }
}
