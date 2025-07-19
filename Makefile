
-include .env

build: 
	forge build

deploy-tokens:
	forge script script/05_DeployTokens.s.sol:DeployTokens \
		--rpc-url sepolia \
		--broadcast \
		--private-key $(PRIVATE_KEY) \
		--verify

deploy-tokens-local:
	forge script script/05_DeployTokens.s.sol:DeployTokens \
		--private-key $(PRIVATE_KEY_LOCAL) \
		--rpc-url local \
		--broadcast

create-pool:
	forge script script/01_CreatePoolAndAddLiquidity.s.sol:CreatePoolAndAddLiquidityScript \
		--rpc-url sepolia \
		--private-key $(PRIVATE_KEY)\
		--broadcast

swap-tokens:
	forge script script/03_Swap.s.sol:SwapScript \
		--rpc-url sepolia \
		--private-key $(PRIVATE_KEY)\
		--broadcast

add-liquidity:
	forge script script/02_AddLiquidity.s.sol:AddLiquidityScript \
		--rpc-url sepolia \
		--private-key $(PRIVATE_KEY)\
		--broadcast

create-local:
	forge script script/01_CreatePoolAndAddLiquidity.s.sol:CreatePoolAndAddLiquidityScript \
		--rpc-url local \
		--private-key $(PRIVATE_KEY_LOCAL) \
		--broadcast

deploy-hook-local:
	forge script script/00_DeployHook.s.sol:DeployHookScript \
		--rpc-url local \
		--private-key $(PRIVATE_KEY_LOCAL) \
		--broadcast

deploy-hook-arb-sepolia:
	forge script script/00_DeployHook.s.sol:DeployHookScript \
		--rpc-url network \
		--private-key $(PRIVATE_KEY) \
		--broadcast

deploy-hook-sepolia:
	forge script script/00_DeployHook.s.sol:DeployHookScript \
		--rpc-url sepolia \
		--private-key $(PRIVATE_KEY) \
		--broadcast

anvil-fork:
	anvil --fork-url network