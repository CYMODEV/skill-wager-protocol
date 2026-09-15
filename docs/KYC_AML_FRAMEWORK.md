# KNOW YOUR CUSTOMER (KYC) & ANTI-MONEY LAUNDERING (AML) FRAMEWORK

**Document Type:** Regulatory Compliance  
**Network:** Polygon L2 / Base  
**Version:** 1.0.0

## 1. Overview

While Skill Wager utilizes decentralized smart contracts for match settlement, the platform operates as a fiat-to-crypto gateway via the ePurse application. To comply with FinCEN, OFAC, and global AML directives, strict identity verification is required at the fiat boundaries.

## 2. The Verification Funnel

Skill Wager utilizes a tiered KYC approach to balance user onboarding friction with regulatory security.

### Tier 0: Unverified (Crypto-Only, Restricted)

- **Action:** User downloads ePurse and connects an existing Web3 wallet.
- **Restrictions:** Can only participate in "Free Play" or use "Tickets". Cannot deposit L1 fiat, cannot purchase PLAY with credit cards, and cannot participate in RMG escrows over 5 $PLAY.

### Tier 1: Standard Verification (Required for RMG)

- **Action:** User completes standard identity verification (Name, DOB, Address, SSN last 4 digits) via our 3rd-party identity provider (e.g., Stripe Identity, Jumio).
- **Capabilities:** Unlocks standard fiat onboarding (Apple Pay, Credit Card to $PLAY). Allows participation in all standard Elo-gated RMG matches.
- **Withdrawal Limit:** $2,000 equivalent per month.

### Tier 2: Enhanced Due Diligence (EDD)

- **Action:** Required for High-Roller matchmaking or withdrawals exceeding Tier 1 limits. Requires government-issued ID scan, liveness check (selfie), and proof of address.
- **Capabilities:** Uncapped withdrawals. Access to VIP High-Roller smart contracts.

## 3. AML Monitoring & Suspicious Activity

### Chip Dumping Prevention

The blockchain ledger is monitored for "chip dumping" (intentionally losing matches to transfer funds to another wallet). If an algorithm detects a High-Elo player consistently losing maximum wagers to the same Low-Elo wallet, both accounts are frozen pending review.

### OFAC Sanctions List

All wallet addresses and verified identities are screened against the live OFAC SDN list. Any matched entities are immediately blacklisted at the smart-contract level.

### Fiat Off-Ramp Security

Withdrawals from $PLAY to Fiat bank accounts must match the verified identity of the Tier 1/2 user. Third-party bank account withdrawals are prohibited.
