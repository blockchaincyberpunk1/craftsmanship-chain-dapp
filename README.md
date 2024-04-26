# Craftsmanship Chain DApp Smart Contracts

The Craftsmanship Chain DApp is currently under development and comprises several smart contracts designed to facilitate various functionalities within the platform. Below is an overview of each contract:

## AuthenticationContract

- **Description**: Manages the registration, update, and verification of craftsmanship and materials used in luxury goods. Utilizes role-based permissions to ensure that certain actions can only be performed by authenticated users with specific roles.

## DisputeResolutionContract

- **Description**: Manages dispute resolution related to the authenticity or ownership of items, facilitating arbitration and evidence presentation.

## IPFSIntegrationContract

- **Description**: Integrates blockchain functionality with IPFS for storing and retrieving large data files, such as images or certificates of authenticity. Stores IPFS hashes on-chain as references to the off-chain data.

## MaterialTrackingContract

- **Description**: Manages and tracks the materials used in the production of goods, focusing on sustainability and ethical sourcing. Allows manufacturers to log materials, their sources, and certifications, and enables users to verify these details.

## OwnershipContract

- **Description**: Tracks ownership of authenticated items, facilitating the transfer of ownership and ensuring transparency. Integrates with the AuthenticationContract to ensure that only authenticated items are transferable.

## PaymentSplitter

- **Description**: This contract can be used when payments need to be received by a group of people and split proportionately according to the number of shares they own.

## ReviewAndRatingContract

- **Description**: Manages reviews and ratings for items, allowing for feedback on authenticity and quality to build trust and transparency in the ecosystem.

## RoyaltyDistributionContract

- **Description**: Manages the distribution of royalties to creators or manufacturers based on the resale of items. Supports setting royalty percentages, tracking sales, and distributing funds accordingly.

## UserManagementContract

- **Description**: Manages user roles and permissions within the DApp, including admin, manufacturer, and customer roles. Utilizes role-based access control for secure interaction.
