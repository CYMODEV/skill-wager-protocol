# GGPO ROLLBACK NETCODE: L2 RMG IMPLEMENTATION GUIDE

**Target Audience:** Senior Network Engineers, Tier B Game Developers  
**Version:** 1.0.0

## 1. The Challenge of Remote RMG Matchmaking

In traditional online gaming, input delay (latency) degrades the user experience. In Real-Money Gaming (RMG), input delay invalidates the "Predominant Skill" legal requirement. If a player loses 100 $PLAY because their input registered 80ms late, the platform's integrity fails.

Skill Wager solves this by mandating Rollback Netcode (GGPO) for all remote (non-local Venue Node) Tier B integrations.

## 2. How Rollback Works with the L2 Oracle

Instead of waiting for the opponent's input to arrive over the network (which causes delay), the Skill Wager SDK locally predicts the opponent's input based on their last known action.

### Process:

1. **Execution:** Both players execute inputs instantly on their local devices at 60 frames per second.
2. **Prediction:** The engine guesses the remote player will continue their current action (e.g., holding forward).
3. **Correction (The Rollback):** When the actual input arrives 50ms later, the engine compares it to the prediction. If the prediction was wrong, the engine instantly rewinds the game state to the point of divergence, injects the correct input, and fast-forwards back to the current frame.

## 3. Developer Requirements for SDK Integration

### Rule 1: Deterministic Game State

To rewind and fast-forward, the game logic must be 100% deterministic. Floating-point math physics engines (like standard Unity PhysX) are inherently non-deterministic across different CPUs.

**Mandate:** Developers must use fixed-point math libraries and custom deterministic collision engines to pass the Skill Wager Compliance Audit.

### Rule 2: Complete State Serialization

The game must be able to save and load its entire state (positions, health, hitboxes, animation frames) in under 2 milliseconds.

**Mandate:** The Skill Wager SDK requires a `SaveGameState(buffer)` and `LoadGameState(buffer)` callback to be fully implemented by the developer.

### Rule 3: Desync Detection & L2 Slashing

In the event that Player A's local machine and Player B's local machine disagree on the final outcome (a Desync), the SDK pushes both serialized match logs to the decentralized Oracle network.

**Cheating Prevention:** If a player is found to have manipulated their local memory to force a desync (cheating), the `OmniEscrow` smart contract executes the Desync Slash Penalty, seizing 100% of the cheater's wager and awarding it to the honest player.
