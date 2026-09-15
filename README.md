# 🕹️ Skill Wager Protocol (SWP)

[![Network](https://img.shields.io/badge/Network-Polygon%20%7C%20Base-blueviolet?style=for-the-badge&logo=polygon)](https://polygon.technology/)
[![Status](https://img.shields.io/badge/Status-Phase%201%20Testnet-orange?style=for-the-badge)](#roadmap)
[![Token](https://img.shields.io/badge/Token-%24PLAY-cyan?style=for-the-badge)](#tokenomics)

**Skill Wager** is a decentralized, Layer-2 infrastructure protocol designed to bridge physical arcade hardware, legacy classic games, and modern indie titles with trustless cryptographic smart contracts. 

By utilizing isolated emulation memory analysis (RAM-hooking) and zero-latency WebSockets, Skill Wager enables secure, real-money skill-based wagering (RMG) without requiring developers to modify underlying game code or risking client-side memory injection.

## 🌐 The Ecosystem

The Skill Wager platform operates as a multi-sided marketplace, uniting players, physical venues, and game publishers into a single economy powered by the **$PLAY** token.

1.  **ePurse (Player Client):** The consumer-facing mobile Web3 wallet. It acts as the financial escrow interface, matchmaking lobby, and a zero-latency virtual gamepad via WebRTC/WSS.
2.  **Venue Node (Coin-Op Alliance):** The physical edge-compute layer. Linux daemons running on smart TVs, projectors, or arcade cabinets in bars and lounges.
3.  **Publisher Registry:** The B2B portal for licensing and deploying games to the network. Developers earn a perpetual 2% volume royalty.

## 🏗️ Quick Start

1. Install dependencies:
```bash
npm install
```

2. Compile the Smart Contracts:
```bash
npx hardhat compile
```

3. Run the local mock Venue Daemon:
```bash
npm run start:daemon
```

---

# SKILL WAGER PROTOCOL: CORE ARCHITECTURE
Version: 1.0
Network Target: Polygon / Base (EVM-Compatible Layer 2)

## 1. Executive Summary
The Skill Wager Protocol is a decentralized infrastructure layer designed to facilitate trustless, real-money skill-based wagering (RMG). By separating game execution from financial settlement, Skill Wager allows legacy arcade games and modern indie titles to participate in a Web3 economy.

The ecosystem utilizes a multi-sided marketplace powered by the $PLAY token, connecting players (liquidity), physical venues (edge-compute), and game publishers (IP) through deterministic Layer-2 smart contracts.

## 2. Platform Architecture & Data Flow
The system achieves a "Trustless Settlement Loop" by abstracting game logic away from the player's mobile device, preventing client-side memory injection and macro exploits.

1. **ePurse (Player Client):** A mobile Web3 wallet. Acts as the financial interface for locking escrows and functions as a zero-latency virtual gamepad via WebRTC/WSS.
2. **Venue Node (Edge Daemon):** A physical device located in a bar or home. It runs the game emulator, processes local WSS inputs, polls memory addresses for win-states, and cryptographically signs match results.
3. **L2 OmniEscrow Contract:** The EVM smart contract that holds $PLAY tokens in escrow. It verifies the ECDSA signature from the Venue Node and executes the payout.

## 3. Economic Model & Tokenomics
The platform operates on a volume-based revenue model, utilizing a standardized 7% Gross Rake on all peer-to-peer wagers.

- **Winner:** 93% (Original stake + opponent stake - 7% rake).
- **Skill Wager Treasury (3%):** Funds platform operations and the Synthetic AMM pool.
- **Game Developer/Publisher (2%):** Perpetual IP royalty.
- **Venue Operator (2%):** Hardware hosting incentive.

## 4. Compliance & Anti-Exploit

- **Input Variance Analysis:** The Venue Node buffers controller telemetry. If input variance falls below human capability thresholds (indicating a macro), the Node aborts the match.
- **Deterministic RNG Seeding:** To eliminate chance, the smart contract generates a seed based on the concatenated transaction hashes of both players' escrow deposits.