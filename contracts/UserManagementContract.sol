// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Importing OpenZeppelin's contract modules for role management and ownership.
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title UserManagementContract
 * @dev Manages user roles and permissions within the dApp, including admin, manufacturer, and customer roles.
 * Utilizes OpenZeppelin's AccessControl for role-based access control and Ownable for ownership management.
 */
contract UserManagementContract is AccessControl, Ownable {
    // Define roles with unique identifiers
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant MANUFACTURER_ROLE = keccak256("MANUFACTURER_ROLE");
    bytes32 public constant CUSTOMER_ROLE = keccak256("CUSTOMER_ROLE");

    /**
     * @dev Constructor that sets up the default admin role and grants the deployer the default admin role.
     */
    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setRoleAdmin(ADMIN_ROLE, DEFAULT_ADMIN_ROLE);
        _setRoleAdmin(MANUFACTURER_ROLE, ADMIN_ROLE);
        _setRoleAdmin(CUSTOMER_ROLE, ADMIN_ROLE);

        // Grant the deployer all roles, including admin, to start with.
        _grantRole(ADMIN_ROLE, msg.sender);
        _grantRole(MANUFACTURER_ROLE, msg.sender);
        _grantRole(CUSTOMER_ROLE, msg.sender);
    }

    /**
     * @dev Modifier to check if the caller has a specific role.
     * Reverts if the caller does not have the role.
     * @param role The role identifier to check.
     */
    modifier onlyRole(bytes32 role) {
        require(hasRole(role, msg.sender), "UserManagementContract: Caller does not have the required role");
        _;
    }

    /**
     * @dev Public function to grant a role to an account.
     * Can only be called by an account with the admin role.
     * @param role The role to be granted.
     * @param account The account to grant the role to.
     */
    function grantRole(bytes32 role, address account) public override onlyRole(getRoleAdmin(role)) {
        super.grantRole(role, account);
    }

    /**
     * @dev Public function to revoke a role from an account.
     * Can only be called by an account with the admin role.
     * @param role The role to be revoked.
     * @param account The account to revoke the role from.
     */
    function revokeRole(bytes32 role, address account) public override onlyRole(getRoleAdmin(role)) {
        super.revokeRole(role, account);
    }

    /**
     * @dev Public function to renounce a role.
     * The function ensures that the caller can renounce roles for itself only.
     * @param role The role to be renounced.
     */
    function renounceRole(bytes32 role) public {
        super.renounceRole(role, msg.sender);
    }
}
