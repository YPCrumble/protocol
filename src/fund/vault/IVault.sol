pragma solidity 0.6.4;

/// @title Vault Interface
/// @author Melon Council DAO <security@meloncoucil.io>
interface IVault {
    function assetBalances(address) external view returns (uint256);
    function deposit(address, uint256) external;
    function getAssetBalances(address[] calldata) external view returns (uint256[] memory);
    function getOwnedAssets() external view returns (address[] memory);
    function withdraw(address, uint256) external;
}

/// @title VaultFactory Interface
/// @author Melon Council DAO <security@meloncoucil.io>
interface IVaultFactory {
     function createInstance(address, address[] calldata) external returns (address);
}
