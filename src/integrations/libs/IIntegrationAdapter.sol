pragma solidity 0.6.4;

/// @title Integration Adapter interface
/// @author Melon Council DAO <security@meloncoucil.io>
interface IIntegrationAdapter {
    function parseIncomingAssets(bytes4, bytes calldata)
        external
        view
        returns (address[] memory);
}
