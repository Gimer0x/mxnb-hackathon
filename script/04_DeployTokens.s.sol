// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import { Script } from "forge-std/Script.sol";
import { MockERC20 } from "src/utils/MockERC20.sol";

import { console } from "forge-std/console.sol";
import {IUniswapV4Router04} from "hookmate/interfaces/router/IUniswapV4Router04.sol";
import {V4RouterDeployer} from "hookmate/artifacts/V4Router.sol";

contract DeployTokens is Script {
    IUniswapV4Router04 swapRouter;
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        /*MockERC20 token0 = new MockERC20("MXNB", "MXNB", 6, 1_000_000 ether);
        MockERC20 token1 = new MockERC20("USDC", "USDC", 6, 1_000_000 ether);

        console.log("Token 0 deployed at: ", address(token0));
        console.log("Token 1 deployed at: ", address(token1));              */
        swapRouter = IUniswapV4Router04(payable(
            V4RouterDeployer.deploy(
                address(0xFB3e0C6F74eB1a21CC1Da29aeC80D2Dfe6C9a317), 
                address(0x000000000022D473030F116dDEE9F6B43aC78BA3))));
        console.log("Swap router deployed at: ", address(swapRouter));
        vm.stopBroadcast();
    }
}