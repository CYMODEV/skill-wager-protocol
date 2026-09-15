# MATCHMAKING & ELO RATING SYSTEM

**Version:** 1.0.0  
**Target:** Network Engineers, Game Designers  
**Algorithm:** Glicko-2 Variant with Anti-Shark Protection

## 1. Elo Rating Fundamentals

### Elo Formula

```
New Rating = Old Rating + K × (Actual Score - Expected Score)
```

Where:
- **K Factor:** 32 (standard players), 48 (new players < 50 matches), 16 (elite players > 2400)
- **Expected Score:** 1 / (1 + 10^((opponent_rating - your_rating) / 400))
- **Actual Score:** 1 (win), 0.5 (draw/tie), 0 (loss)

### Rating Brackets

| Bracket | Rating Range | Estimated % of Player Base |
|---------|--------------|----------------------------|
| Bronze | 0-1200 | 45% |
| Silver | 1200-1600 | 35% |
| Gold | 1600-2000 | 15% |
| Platinum | 2000-2400 | 4% |
| Diamond | 2400+ | 1% |

## 2. Matchmaking Algorithm

### Primary Goals
1. **Skill Balance:** Pair players within ±200 rating points
2. **Queue Time Minimization:** Match within 30 seconds if possible
3. **Anti-Shark Protection:** Prevent high-ranked players from farming low-rank players

### Matchmaking Tiers

```javascript
// Tier 1: Tight Matching (0-30s wait)
if (queue_wait < 30s && abs(player_rating - opponent_rating) < 100) {
  acceptMatch();
}

// Tier 2: Standard Matching (30-60s wait)
if (queue_wait >= 30s && abs(player_rating - opponent_rating) < 200) {
  acceptMatch();
}

// Tier 3: Expanded Matching (60s+ wait)
if (queue_wait >= 60s && abs(player_rating - opponent_rating) < 400) {
  // Require additional consent
  await player.confirmExpandedMatch();
}
```

## 3. Anti-Shark Protocol

### Shark Detection Rules

A player is flagged as a potential "shark" if:
- Win rate > 75% against players rated 300+ points lower
- Average opponent rating is 400+ points lower than their rating
- Win streak > 15 matches against dramatically lower-ranked opponents

### Enforcement Actions

1. **Warning (1st offense):** Notification sent
2. **Queue Penalty (2nd offense):** 5-minute matchmaking cooldown
3. **Rating Penalty (3rd+ offense):** -50 rating points per violation

### Compensation for Victims

If a low-rated player (e.g., 1000) loses to a high-rated "shark" (e.g., 2200):
- Normal loss: -16 Elo
- Shark-matched loss: -8 Elo (50% penalty reduced)
- Shark-matched win: +32 Elo (50% bonus awarded)

## 4. Provisional Rating System

**New Players (< 50 matches):**
- Use higher K-factor (48 instead of 32)
- Rating stabilizes after 50 matches
- Cannot queue against rated players until first 5 matches complete

**Placement Matches:**
- First 5 matches determine provisional rating
- Rating can swing ±100 points per match
- After 50 matches: Transition to standard Elo

## 5. Rating Decay & Seasonal Reset

### Inactivity Decay

- No matches for 30 days: -10 rating/week
- Decay stops at Bronze tier (1200)
- Decay resumes when player reactivates

### Seasonal Reset (Quarterly)

- Top 1% (Diamond+): -50 rating points, kept if still Diamond
- Top 10% (Platinum+): -30 rating points
- Everyone else: No penalty, optional rating reset

## 6. Uncertainty & Glicko-2

```javascript
// Glicko-2 RD (Rating Deviation) for uncertainty
class GlickoRating {
  constructor(rating, rd, volatility) {
    this.rating = rating;        // Base Elo
    this.rd = rd;                // Rating deviation (confidence)
    this.volatility = volatility; // Variance
  }

  updateMatch(opponentRating, opponentRD, result) {
    // Reduce RD after each match (higher confidence)
    this.rd = Math.max(30, this.rd - 5);
    
    // Apply Elo formula
    const expectedScore = this.expectedScore(opponentRating);
    this.rating += 32 * (result - expectedScore);
  }

  expectedScore(opponentRating) {
    return 1 / (1 + Math.pow(10, (opponentRating - this.rating) / 400));
  }
}
```

## 7. Tournament Elo Adjustments

### Prize Pool Multiplier

- **Small Tournament (10-50 players):** 1x Elo variance
- **Large Tournament (51-500 players):** 1.5x Elo variance
- **Major Championship (500+ players):** 2x Elo variance

Winner gains extra rating; losers lose slightly more.

### Bracket-Specific Ratings

Different games can have separate Elo ratings:
- Chess: Elo
- Fighting Games: Elo
- Racing: Elo
- Puzzle: Elo

Players maintain separate ratings per game category.

## 8. Monitoring & Anomaly Detection

### Flagged for Review

- Win rate changes by >20% in 24 hours
- Average match duration differs by >30% from baseline
- Same opponent matched 5+ times in 24 hours
- Input patterns suggest bot behavior

### Automatic Actions

```javascript
if (anomalies.detected) {
  // Freeze rating updates
  player.freezeRating();
  
  // Submit match logs to Oracle for verification
  await oracle.submitSuspiciousMatchLog(matchId);
  
  // Pending manual review by compliance team
}
```

## 9. API Endpoints

- `GET /player/:id/rating` - Get current Elo & stats
- `GET /player/:id/rating/history` - Rating over time
- `POST /matchmaking/queue/:gameId` - Enter queue
- `GET /matchmaking/opponents` - Potential opponents
- `GET /leaderboard/:bracket` - Ranked leaderboard
