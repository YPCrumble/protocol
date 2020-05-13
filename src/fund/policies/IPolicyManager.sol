pragma solidity 0.6.4;
pragma experimental ABIEncoderV2;

/// @title PolicyManager Interface
/// @author Melon Council DAO <security@meloncoucil.io>
interface IPolicyManager {
    enum PolicyHook { None, BuyShares, CallOnIntegration }
    enum PolicyHookExecutionTime { None, Pre, Post }

    function enablePolicies(address[] calldata, bytes[] calldata) external;
    function postValidatePolicy(PolicyHook, bytes calldata) external view;
    function preValidatePolicy(PolicyHook, bytes calldata) external view;
}

/// @title PolicyManagerFactory Interface
/// @author Melon Council DAO <security@meloncoucil.io>
interface IPolicyManagerFactory {
    function createInstance(address _hub) external returns (address);
}
