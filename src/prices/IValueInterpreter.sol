pragma solidity 0.6.4;

/// @title IValueInterpreter interface
/// @author Melon Council DAO <security@meloncoucil.io>
interface IValueInterpreter {
    function calcCanonicalAssetValue(address, uint256, address) external view returns (uint256, bool);
    function calcLiveAssetValue(address, uint256, address) external view returns (uint256, bool);
}
