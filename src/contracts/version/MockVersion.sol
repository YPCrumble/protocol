pragma solidity ^0.5.13;

import "../fund/hub/Hub.sol";

/// @notice Version contract useful for testing
contract MockVersion {
    uint public amguPrice;
    bool public isShutDown;

    function setAmguPrice(uint _price) public { amguPrice = _price; }
    function securityShutDown() external { isShutDown = true; }
    function shutDownFund(address _hub) external { Hub(_hub).shutDownFund(); }
    function getShutDownStatus() external view returns (bool) {return isShutDown;}
    function getAmguPrice() public view returns (uint) { return amguPrice; }
}
