# MEV Mitigation Hook for Uniswap V4

A sophisticated MEV (Maximal Extractable Value) mitigation hook for Uniswap V4 that dynamically adjusts fees based on detected front-running, back-running, and sandwich attack patterns. This hook is specifically designed for MXNB/USDC liquidity pools on Arbitrum Sepolia.

## 🎯 Overview

This project implements an intelligent fee adjustment mechanism that protects liquidity providers from common MEV attacks by:

- **Front-running Detection**: Monitors transaction priority fees to detect potential front-running attempts
- **Back-running Protection**: Tracks price movements within the same block to identify back-running patterns
- **Sandwich Attack Mitigation**: Detects opposite-direction swaps in the same block and adjusts fees accordingly
- **Volatility-Based Pricing**: Integrates with Chainlink price feeds to adjust fees based on market volatility

## 🏗️ Architecture

### Core Components

- **MEVMitigationHook**: Main hook contract implementing the MEV protection logic
- **PriceConsumerV3**: Chainlink price feed integration for volatility assessment
- **Dynamic Fee System**: Adaptive fee structure based on attack patterns and market conditions

### Fee Structure

| Attack Type | Fee Increase | Description |
|-------------|--------------|-------------|
| Base Fee | 0.03% | Initial pool fee |
| Front-running | +0.5% | High priority fee detection |
| Back-running | +0.6% | Price manipulation detection |
| Low Volatility | +1.0% | Market stability period |
| Medium Volatility | +1.5% | Normal market conditions |
| High Volatility | +2.0% | High market volatility |

## 🚀 Quick Start

### Prerequisites

- [Foundry](https://getfoundry.sh/) (latest stable version)
- Node.js and npm
- Access to Arbitrum Sepolia testnet

### Installation

1. **Clone and install dependencies:**
   ```bash
   git clone <repository-url>
   cd mxnb-hackathon
   forge install
   ```

2. **Set up environment variables:**
   ```bash
   cp .env.example .env
   ```
   
   Add your configuration to `.env`:
   ```env
   PRIVATE_KEY=your_private_key_here
   PRIVATE_KEY_LOCAL=your_local_test_key
   ARBITRUM_SEPOLIA_RPC=your_rpc_url
   ```

3. **Build the project:**
   ```bash
   make build
   ```

4. **Run tests:**
   ```bash
   forge test
   ```

## 📋 Deployment Guide

### 1. Deploy Hook to Arbitrum Sepolia

```bash
make deploy-hook-arb-sepolia
```

**Important**: After deployment, update the hook address in `script/base/BaseScript.sol`:
```solidity
IHooks constant hookContract = IHooks(0xYOUR_DEPLOYED_HOOK_ADDRESS);
```

### 2. Deploy Tokens (if needed)

```bash
make deploy-tokens
```

### 3. Create Liquidity Pool

Configure your liquidity position in `script/01_CreatePoolAndAddLiquidity.s.sol`:
```solidity
uint256 public token0Amount = 18740e6; // MXNB amount
uint256 public token1Amount = 1000e6;  // USDC amount
```

Then create the pool:
```bash
make create-pool
```

### 4. Execute Swaps

```bash
make swap-tokens
```

## 🧪 Testing

### Local Development

1. **Start local anvil instance:**
   ```bash
   make anvil-fork
   ```

2. **Deploy hook locally:**
   ```bash
   make deploy-hook-local
   ```

3. **Create local pool:**
   ```bash
   make create-local
   ```

### Test Coverage

The project includes comprehensive tests covering:
- Front-running fee detection
- Back-running mitigation
- Sandwich attack protection
- Volatility-based fee adjustments

Run tests with:
```bash
forge test
```

## 🔧 Configuration

### Hook Parameters

Key parameters can be adjusted in `src/MEVMitigationHook.sol`:

```solidity
uint24 public constant INITIAL_FEE = 300;        // 0.03%
uint24 public constant BASE_FEE = 5_000;         // 0.5%
uint24 public constant LOWER_PRICE_FEE = 6_000;  // 0.6%
uint24 public HIGH_VOLATILITY_FEE = 20_000;      // 2.0%
uint24 public MEDIUM_VOLATILITY_FEE = 15_000;    // 1.5%
uint24 public LOW_VOLATILITY_FEE = 10_000;       // 1.0%
```

### Volatility Thresholds

Volatility-based fee adjustments:
- **Low Volatility**: < 75 (1.0% fee)
- **Medium Volatility**: 75-200 (1.5% fee)
- **High Volatility**: ≥ 200 (2.0% fee)

## 📊 Contract Addresses

### Arbitrum Sepolia

| Contract | Address |
|----------|---------|
| Hook Contract | `0xc588c10682461BacFB24d14f75D1a60f0E9E6080` |
| MXNB Token | `0x82B9e52b26A2954E113F94Ff26647754d5a4247D` |
| USDC Token | `0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d` |
| Price Feed | `0x03121C1a9e6b88f56b27aF5cc065ee1FaF3CB4A9` |

### Demo Transaction

View the demonstration swap transaction: [Arbiscan](https://sepolia.arbiscan.io/tx/0x562b4beb80eb1aeace521ba76fb5575dfd81d3bcafabf3e3f57bab1d0bda67c8)

## 🛠️ Available Commands

| Command | Description |
|---------|-------------|
| `make build` | Build all contracts |
| `make deploy-hook-arb-sepolia` | Deploy hook to Arbitrum Sepolia |
| `make deploy-hook-local` | Deploy hook locally |
| `make create-pool` | Create pool on Arbitrum Sepolia |
| `make create-local` | Create pool locally |
| `make swap-tokens` | Execute swap on Arbitrum Sepolia |
| `make anvil-fork` | Start local anvil with Arbitrum Sepolia fork |

## 🔍 How It Works

### MEV Detection Logic

1. **Front-running Detection**:
   - Monitors transaction priority fees (EIP-1559 tips)
   - Increases fees when priority fees exceed threshold (10 gwei)

2. **Back-running Protection**:
   - Tracks price movements within the same block
   - Detects price decreases that indicate back-running attempts

3. **Sandwich Attack Mitigation**:
   - Identifies opposite-direction swaps in the same block
   - Applies additional fees based on market volatility

4. **Volatility Assessment**:
   - Integrates with Chainlink price feeds
   - Adjusts fees based on market volatility levels

### Gas Optimization

The hook uses several gas optimization techniques:
- Packed storage for mapping keys
- Efficient bit manipulation for price calculations
- Minimal storage operations

## 🚨 Troubleshooting

### Common Issues

1. **Hook Deployment Failures**:
   - Ensure you're using the latest Foundry version
   - Check that CREATE2 factory is available on your network
   - Verify hook flags match the deployed address

2. **Gas Limit Issues**:
   - Increase gas limit for hook deployment: `--gas-limit 50000000`
   - Hook mining can be gas-intensive

3. **Test Failures**:
   - Update Foundry: `foundryup`
   - Clear cache: `forge clean`
   - Check dependency versions

### Environment Setup

For local development:
```bash
# Start anvil with higher gas limit
anvil --gas-limit 50000000

# In another terminal
forge script script/00_DeployHook.s.sol:DeployHookScript \
  --rpc-url local \
  --private-key YOUR_PRIVATE_KEY \
  --broadcast \
  --gas-limit 50000000
```

## 📚 Resources

- [Uniswap V4 Documentation](https://docs.uniswap.org/contracts/v4/overview)
- [V4 Hooks Template](https://github.com/uniswapfoundation/v4-template)
- [Foundry Documentation](https://book.getfoundry.sh/)
- [Chainlink Price Feeds](https://docs.chain.link/data-feeds)

## 📄 License

This project is licensed under the MIT License.

---

**Note**: This hook is designed for educational and experimental purposes. Always test thoroughly before using in production environments.

