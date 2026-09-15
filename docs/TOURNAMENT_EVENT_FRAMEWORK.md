# TOURNAMENT & EVENT FRAMEWORK

**Version:** 1.0.0  
**Target:** Event Organizers, Tournament Directors, Spectators

## 1. Tournament Types

### Format 1: Single Elimination

**Best for:** Quick casual tournaments (1-2 hours)
- Bracket size: 8, 16, 32, 64 players
- Prize distribution: Winner gets 60%, Runner-up 25%, 3rd place 15%
- Example: Local arcade $100 tournament

### Format 2: Swiss System

**Best for:** Skill-balanced competition
- Rounds: Typically 5-7 rounds
- Matchmaking: Based on current record + Elo
- Prize distribution: Win/loss record determines payouts
- Example: Regional $1,000 championship

### Format 3: Round-Robin

**Best for:** League play over weeks/months
- Rounds: Each player plays every other player
- Ranking: Based on W-L-D record
- Promotion/Demotion: Top players move up divisions
- Example: Monthly pro league with $10,000 prize pool

## 2. Parimutuel Betting & Spectator Staking

### How Parimutuel Works

1. **Wager Pool:** Spectators stake $PLAY on match outcomes
2. **Rake Deduction:** 5% of pool goes to treasury
3. **Payout Distribution:** Remaining 95% split among winning bettors

### Example

**Match:** Player A (Elo 2000) vs Player B (Elo 1600)

```
Spectator Stakes:
  - $10,000 on Player A
  - $4,000 on Player B
  - Total Pool: $14,000

Prize Pool After Rake:
  - $14,000 × 0.95 = $13,300

If Player A Wins:
  - Payout to A bettors: $13,300
  - Individual return: $13,300 / 10,000 × $100 = $133
  - Profit: $33 per $100 staked

If Player B Wins:
  - Payout to B bettors: $13,300
  - Individual return: $13,300 / 4,000 × $100 = $332.50
  - Profit: $232.50 per $100 staked (higher odds, underdog)
```

### Odds Calculation

```javascript
// Real-time odds update as spectators stake
function calculateOdds(pool_player_a, pool_player_b) {
  const total_pool = pool_player_a + pool_player_b;
  const implied_prob_a = pool_player_a / total_pool;
  
  // American odds
  const odds_a = implied_prob_a > 0.5 
    ? (-100 / (implied_prob_a / (1 - implied_prob_a)))
    : (100 * ((1 - implied_prob_a) / implied_prob_a));
    
  return { odds_player_a: odds_a };
}
```

## 3. Prize Pool Management

### Allocation Structure

**$10,000 Tournament Prize Pool Example:**

| Placement | Prize | Allocation |
|-----------|-------|-----------|
| 1st Place | $6,000 | 60% |
| 2nd Place | $2,500 | 25% |
| 3rd-4th Place | $750 each | 15% |
| 5th-8th Place | $0 | Participation points |

### Creator Cut

- Tournament organizer retains 10% of entry fees
- Skill Wager takes 5% (rake)
- Remaining 85% goes to prize pool

**Example:** 100 players × $100 entry = $10,000
- Organizer: +$1,000
- Skill Wager: +$500
- Prize pool: +$8,500

## 4. Broadcasting & Spectator Experience

### Integration with Twitch/YouTube

```javascript
// Embed match stream in tournament dashboard
const broadcastConfig = {
  platform: 'twitch',
  channel: 'skillwager_championship',
  game_category: 'fighting_games',
  
  // Overlay data
  overlays: {
    player_names: true,
    player_ratings: true,
    prize_money: true,
    spectator_odds: true,
    live_betting: true
  }
};
```

### Spectator Dashboard Features

- **Live Match Feed:** Multiple matches displayed simultaneously
- **Odds Ticker:** Real-time odds updates as spectators stake
- **Player Stats:** Rating, win/loss record, head-to-head stats
- **Chat Integration:** Spectators chat during broadcasts
- **Highlight Reels:** AI-generated clips of clutch moments

## 5. League Play & Seasonal Ranking

### Seasonal Structure

**Each season: 12 weeks**

- Weeks 1-10: Regular season play (Swiss format)
- Weeks 11-12: Playoffs (Top 8 single-elim)

### Division System

| Division | Elo Range | Promotion | Relegation |
|----------|-----------|-----------|-----------|
| Diamond | 2400+ | N/A | Top 100 drop to Platinum |
| Platinum | 2000-2399 | Win 10 matches | Lose 5 consecutive |
| Gold | 1600-1999 | Win 8 matches | Lose 5 consecutive |
| Silver | 1200-1599 | Win 6 matches | Lose 5 consecutive |
| Bronze | 0-1199 | N/A | N/A |

### Seasonal Rewards

- **Season Pass:** $5 one-time unlock (cosmetics, bonus XP)
- **Rank Rewards:** Cosmetics for reaching Gold+
- **Prize Pool:** Top 100 players share $50,000
  - 1st: $10,000
  - 2nd-5th: $5,000 each
  - 6th-10th: $2,000 each
  - 11th-100th: Tiered down to $100

## 6. Community Tournaments (DAO-Funded)

### How to Propose a Tournament

1. **Create proposal** in DAO governance
2. **Request prize pool** from Community Rewards (max $50,000)
3. **Outline format, rules, streaming plan**
4. **DAO vote** (24-hour period)
5. **If approved:** Funds released to organizer wallet

### Requirements

- Tournament must be **streamed live** (Twitch/YouTube)
- Minimum **100 participants** or **$10,000 buy-in**
- Results **submitted on-chain** for verification
- Organizer must **stake 5% of prize pool** as collateral

## 7. Tournament API

### Create Tournament

```
POST /tournaments
{
  "name": "Regional Championship",
  "format": "swiss",
  "game_id": "street-fighter-6",
  "entry_fee": 50,
  "max_players": 256,
  "start_time": "2026-10-15T18:00:00Z",
  "prize_pool": 10000,
  "streaming_url": "https://twitch.tv/skillwager"
}
```

### Match Management

```
GET /tournaments/:id/matches
POST /tournaments/:id/matches/:match_id/submit-result
GET /tournaments/:id/leaderboard
GET /tournaments/:id/bracket
```

## 8. Anti-Collusion Monitoring

### Detection Systems

```javascript
// Flag suspicious activity
if (
  player_a_win_rate_vs_player_b > 90% &&
  matches_together > 10 &&
  average_time_to_win < 30_seconds
) {
  flag_for_review({
    reason: 'Potential collusion',
    players: [player_a, player_b],
    confidence: 0.85
  });
}
```

### Penalties

- **Confirmed Collusion:** Both players banned from tournaments
- **Prize Clawback:** Any winnings forfeited to treasury
- **Reputation Damage:** Public listing on ban registry

## 9. Accessibility Features

- **Closed Captions:** Live broadcast captioning
- **Controller Support:** Xbox, PlayStation, arcade stick compatible
- **Colorblind Mode:** Deuteranopia, Protanopia, Tritanopia filters
- **Audio Description:** For spectators with visual impairment
