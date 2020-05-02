pragma solidity 0.6.4;
pragma experimental ABIEncoderV2;

import "../libs/OrderTaker.sol";
import "../libs/decoders/MinimalTakeOrderDecoder.sol";
import "../../dependencies/WETH.sol";
import "../../engine/IEngine.sol";

/// @title EngineAdapter Contract
/// @author Melon Council DAO <security@meloncoucil.io>
/// @notice Trading adapter to Melon Engine
contract EngineAdapter is OrderTaker, MinimalTakeOrderDecoder {
    function parseIncomingAssets(bytes4 _selector, bytes calldata _encodedArgs)
        external
        view
        override
        returns (address[] memory incomingAssets_)
    {
        if (_selector == TAKE_ORDER_SELECTOR) {
            (address makerAsset,,,) = __decodeTakeOrderArgs(_encodedArgs);
            incomingAssets_ = new address[](1);
            incomingAssets_[0] = makerAsset;
        }
        else {
            revert("parseIncomingAssets: _selector invalid");
        }
    }

    /// @notice Buys Ether from the Melon Engine, selling MLN (takeOrder)
    /// @param _targetExchange Address of the Melon Engine
    /// @param _encodedArgs Encoded parameters passed from client side
    /// @param _fillData Encoded data to pass to OrderFiller
    function __fillTakeOrder(
        address _targetExchange,
        bytes memory _encodedArgs,
        bytes memory _fillData
    )
        internal
        override
        validateAndFinalizeFilledOrder(_targetExchange, _fillData)
    {
        (
            address[] memory fillAssets,
            uint256[] memory fillExpectedAmounts,
        ) = __decodeOrderFillData(_fillData);

        // Fill order on Engine
        uint256 preEthBalance = payable(address(this)).balance;
        IEngine(_targetExchange).sellAndBurnMln(fillExpectedAmounts[1]);
        uint256 ethFilledAmount = sub(payable(address(this)).balance, preEthBalance);

        // Return ETH to WETH
        WETH(payable(fillAssets[0])).deposit.value(ethFilledAmount)();
    }

    /// @notice Formats arrays of _fillAssets and their _fillExpectedAmounts for a takeOrder call
    /// @param _targetExchange Address of the Melon Engine
    /// @param _encodedArgs Encoded parameters passed from client side
    /// @return fillAssets_ Assets to fill
    /// - [0] Maker asset (same as _orderAddresses[2])
    /// - [1] Taker asset (same as _orderAddresses[3])
    /// @return fillExpectedAmounts_ Asset fill amounts
    /// - [0] Expected (min) quantity of WETH to receive
    /// - [1] Expected (max) quantity of MLN to spend
    /// @return fillApprovalTargets_ Recipients of assets in fill order
    /// - [0] Taker (fund), set to address(0)
    /// - [1] Melon Engine (_targetExchange)
    function __formatFillTakeOrderArgs(
        address _targetExchange,
        bytes memory _encodedArgs
    )
        internal
        view
        override
        returns (address[] memory, uint256[] memory, address[] memory)
    {
        (
            address makerAsset,
            uint256 makerQuantity,
            address takerAsset,
            uint256 takerQuantity
        ) = __decodeTakeOrderArgs(_encodedArgs);

        address[] memory fillAssets = new address[](2);
        fillAssets[0] = makerAsset;
        fillAssets[1] = takerAsset;

        uint256[] memory fillExpectedAmounts = new uint256[](2);
        fillExpectedAmounts[0] = makerQuantity;
        fillExpectedAmounts[1] = takerQuantity;

        address[] memory fillApprovalTargets = new address[](2);
        fillApprovalTargets[0] = address(0); // Fund (Use 0x0)
        fillApprovalTargets[1] = _targetExchange; // Oasis Dex exchange

        return (fillAssets, fillExpectedAmounts, fillApprovalTargets);
    }

    /// @notice Validate the parameters of a takeOrder call
    /// @param _targetExchange Address of the Melon Engine
    /// @param _encodedArgs Encoded parameters passed from client side
    function __validateTakeOrderParams(
        address _targetExchange,
        bytes memory _encodedArgs
    )
        internal
        view
        override
    {
        (
            address makerAsset,
            ,
            address takerAsset
            ,
        ) = __decodeTakeOrderArgs(_encodedArgs);

        require(
            makerAsset == __getNativeAssetAddress(),
            "__validateTakeOrderParams: maker asset does not match nativeAsset"
        );
        require(
            takerAsset == __getMlnTokenAddress(),
            "__validateTakeOrderParams: taker asset does not match mlnToken"
        );
    }
}
