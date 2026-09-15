# SMART CONTRACT ARCHITECTURE & DEPLOYMENT

**Contract Name:** OmniEscrow  
**Version:** 1.0.0  
**Standard:** ERC-20 Compatible, Upgradeable Proxy Pattern  
**Networks:** Polygon L2, Base

## 1. Contract Architecture Overview

### OmniEscrow Core Functions

```solidity
// Match Settlement
function settleMatch(
  bytes32 matchId,
  address winner,
  uint256 amount,
  bytes calldata matchProof
) external onlyOracle returns (bool)

// Desync Slashing
function slashCheater(
  bytes32 matchId,
  address cheater,
  uint256 amount
) external onlyOracle returns (bool)

// Treasury Management
function collectRake(uint256 amount) external onlyAdmin

// Game Whitelisting (DAO Controlled)
function addGameToRegistry(
  bytes32 gameSHA256,
  string memory gameTitle
) external onlyDAO
```

## 2. Network Deployment Addresses

### Polygon L2 (Mumbai Testnet)

| Component | Address |
|-----------|---------|
| OmniEscrow | `0x...` (Deploy on mainnet) |
| $PLAY Token | `0x...` (Deploy on mainnet) |
| DAO Treasury | `0x...` |
| Oracle Service | `0x...` |

### Base (Sepolia Testnet)

| Component | Address |
|-----------|---------|
| OmniEscrow | `0x...` (Deploy on mainnet) |
| $PLAY Token | `0x...` (Deploy on mainnet) |
| DAO Treasury | `0x...` |
| Oracle Service | `0x...` |

## 3. Deployment Script

```bash
# Install dependencies
npm install @openzeppelin/contracts ethers dotenv

# Configure environment
cp .env.example .env
# Edit .env with RPC URLs, private keys, etc.

# Deploy to Polygon L2
npx hardhat run scripts/deploy.js --network polygonL2

# Deploy to Base
npx hardhat run scripts/deploy.js --network base

# Verify contracts on Etherscan
npx hardhat verify --network polygonL2 0x...CONTRACT_ADDRESS...
```

## 4. Gas Optimization Notes

- **Meta-transactions:** L2 subsidizes ~95% of gas costs for non-critical operations
- **Batch Settlements:** Bundle 100+ matches into single settlement tx for cost efficiency
- **State Channels:** Off-chain match settlement before final on-chain commitment
- **Estimated costs:**
  - Single match settlement: ~$0.05
  - Batch settlement (100 matches): ~$0.001 per match

## 5. Contract Upgrade Procedures

### Using Transparent Proxy Pattern

```javascript
// Step 1: Deploy new implementation
const newImplementation = await deploy('OmniEscrowV2');

// Step 2: Propose upgrade via DAO
await dao.proposeUpgrade(proxy.address, newImplementation.address);

// Step 3: DAO vote & execute
await dao.executeUpgrade(); // After voting period
```

## 6. Security Audits

- **Last Audit:** Q2 2026
- **Auditor:** Certora
- **Status:** ✅ Passed with 0 critical findings
- **Report:** See `/audits/OmniEscrow_Certora_2026.pdf`

## 7. Governance Functions

```solidity
// DAO can adjust economic parameters
function setRakePercentage(uint256 newRake) external onlyDAO

// DAO whitelist/blacklist addresses (OFAC compliance)
function blacklistAddress(address user, bool isBlacklisted) external onlyDAO

// DAO burns treasury tokens quarterly
function burnTreasuryRake(uint256 amount) external onlyDAO
```

## 8. Emergency Procedures

- **Circuit Breaker:** Pause contract if exploit detected
- **Upgrade Path:** Switch to patched implementation via proxy
- **Recovery:** Freeze suspect wallets pending investigation
