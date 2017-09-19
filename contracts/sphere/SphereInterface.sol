pragma solidity ^0.4.15;

/// @title Sphere Interface Contract
/// @author Melonport AG <team@melonport.com>
/// @notice This is to be considered as an interface on how to access the underlying Sphere Contract
contract SphereInterface {

    // CONSTANT METHODS

    function getDataFeed() external constant returns (address) {}
    function getConsigned() external constant returns (address) {}
    function getExchangeAdapter() external constant returns (address) {}
}
