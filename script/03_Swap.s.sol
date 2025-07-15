// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";

import {BaseScript} from "./base/BaseScript.sol";
import {LPFeeLibrary} from "v4-core-hook/libraries/LPFeeLibrary.sol";

contract SwapScript is BaseScript {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        PoolKey memory poolKey = PoolKey({
            currency0: currency0,
            currency1: currency1,
            fee: LPFeeLibrary.DYNAMIC_FEE_FLAG,
            tickSpacing: 10,
            hooks: hookContract // This must match the pool
        });
        bytes memory hookData = new bytes(0);

        // We'll approve both, just for testing.
        token1.approve(address(swapRouter), type(uint256).max);
        token0.approve(address(swapRouter), type(uint256).max);

        // Execute swap
        swapRouter.swapExactTokensForTokens({
            amountIn: 1e6,
            amountOutMin: 0, // Very bad, but we want to allow for unlimited price impact
            zeroForOne: true,
            poolKey: poolKey,
            hookData: hookData,
            receiver: address(0x0d2Dc4E9ebc1465E86Fdf6ab18377CB82eCf7548),
            deadline: block.timestamp + 1 hours
        });

        vm.stopBroadcast();
    }
}
