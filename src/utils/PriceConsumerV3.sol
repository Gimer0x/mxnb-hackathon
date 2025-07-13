// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {DataFeedsScript} from "lib/foundry-chainlink-toolkit/script/feeds/DataFeed.s.sol";

contract PriceConsumerV3 {
    DataFeedsScript public volatilityFeed;

    // DAI vs USD 0x14866185B1962B63C3Ea9E03Bc1da838bab34C19
    constructor(address _priceFeed) {
        volatilityFeed = DataFeedsScript(
            _priceFeed
        );
    }

    function getLatestRoundData() external view returns (int256 volatility) {
        (
            /* uint80 roundID */,
            int256 answer,
            /* uint256 startedAt */,
            /* uint256 updatedAt */,
            /* uint80 answeredInRound */
        ) = volatilityFeed.getLatestRoundData();

        volatility = (answer * 100) / int256(10 ** uint256(getDecimals()));
    }

    function getDecimals()
        public
        view
        returns (uint8)
    {
        return volatilityFeed.getDecimals();
    }
}