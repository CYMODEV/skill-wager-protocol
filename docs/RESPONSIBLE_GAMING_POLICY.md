# SKILL WAGER: RESPONSIBLE GAMING & PLAYER PROTECTION POLICY

**Version:** 1.0.0  
**Last Updated:** September 2026

## 1. Core Philosophy

Skill Wager operates at the intersection of competitive esports and real-money gaming (RMG). We are committed to fostering a safe, sustainable, and transparent competitive environment. Because our platform facilitates financial escrows via the $PLAY token, we enforce strict player protection protocols that align with industry best practices for both traditional RMG and Web3 ecosystems.

## 2. Age and Jurisdiction Gating

- **Minimum Age:** All users must be 18 years of age or older (or 21+ where mandated by local jurisdiction) to participate in real-money wagers using $PLAY.

- **Geofencing:** The ePurse application utilizes GPS and IP tracking to enforce geographic compliance. Wagers are instantly disabled if a user's node connects from a restricted jurisdiction (e.g., Arkansas, Tennessee, Montana) where skill-based gaming for money is prohibited. In these zones, the app defaults strictly to "Free Play" or "Ticket/Amusement" modes.

## 3. Financial Safeguards & Wager Limits

To prevent "chasing losses" and ensure sustainable engagement, the platform enforces hard-coded limits via the Layer-2 smart contract:

### Elo-Gated Wagering Ceiling:
- **Casual Tier (Elo < 1200):** Max 10 $PLAY per match.
- **Competitor Tier (Elo 1200 - 1800):** Max 100 $PLAY per match.
- **High Roller (Elo 1800+):** Uncapped.

### Daily Loss Limits:
Users can set maximum rolling 24-hour loss limits in their ePurse settings. Once hit, the smart contract will reject all escrow requests from that wallet address until the timeout expires.

### Cool-Down Periods:
If a user loses 5 consecutive matches within a 60-minute window, the app enforces a mandatory 15-minute cool-down period.

## 4. Self-Exclusion Program

Players who feel they are losing control of their play habits can execute a cryptographic self-exclusion:

- **Timeout:** 24 hours to 30 days.
- **Permanent Exclusion:** A user can flag their wallet address for permanent exclusion. The Skill Wager smart contracts will permanently blacklist the address from initiating or joining escrows. Note: Users can still withdraw their remaining funds to L1 at any time.

## 5. Anti-Predator (Anti-Shark) Protocols

To protect casual players from being exploited by highly skilled players (hustling), the matchmaking smart contract enforces strict Elo deltas. If a player attempts to challenge an opponent with an Elo rating more than 400 points lower than their own, the escrow is automatically rejected.