# VENUE NODE OPERATOR HANDBOOK

**Version:** 1.0.0  
**Target:** Arcade Operators, Bar/Restaurant Owners, Esports Venue Managers

## 1. Hardware Setup & Configuration

### Minimum System Requirements

**Per Arcade Cabinet:**
- CPU: Intel i7 / AMD Ryzen 7 (or equivalent)
- GPU: NVIDIA GTX 1660 / RTX 3060 (or equivalent)
- RAM: 16GB DDR4
- Storage: 1TB SSD (NVMe preferred)
- Network: Gigabit Ethernet (1000 Mbps minimum)
- Latency: <10ms to nearest Skill Wager node

**Node Server (Centralized for venue):**
- CPU: Intel Xeon / AMD EPYC (8+ cores)
- RAM: 64GB DDR4
- Storage: 4TB SSD RAID-1
- Network: 10Gbps dedicated connection
- UPS: 8+ hour battery backup
- Redundant power supplies

### Network Architecture

```
┌─────────────────────────────────────────┐
│        Skill Wager L2 Oracle            │
│      (Polygon/Base Mainnet)             │
└──────────────┬──────────────────────────┘
               │
        ┌──────┴─────────┐
        │                │
    [Venue A]        [Venue B]
   Node Server      Node Server
        │                │
    ┌───┴────┐       ┌───┴────┐
  [Game 1] [Game 2] [Game 1] [Game 2]
```

### Installation Steps

1. **Deploy Node Server**
   ```bash
   docker pull skillwager/node-operator:latest
   docker run -d \
     -e VENUE_ID=YOUR_VENUE_ID \
     -e PRIVATE_KEY=YOUR_NODE_OPERATOR_KEY \
     -v /data:/data \
     skillwager/node-operator
   ```

2. **Connect Game Cabinets**
   - Each cabinet connects via SDK to Node Server
   - Node Server syncs with L2 Oracle every 10 seconds
   - All matches streamed to blockchain in batches

3. **Monitor Uptime**
   - Venue must maintain 99.5%+ uptime
   - Downtime >4 hours triggers slashing
   - Backup nodes recommended for high-volume venues

## 2. Node Treasury & Staking

### Locking $PLAY for 1.2x Voting Multiplier

**Why Lock $PLAY?**
- Earn 2% annual yield on staked tokens
- Receive 1.2x voting power in DAO decisions
- First priority for new game launches
- Reduced fee structure (6.5% rake instead of 7%)

### Staking Tiers

| Tier | $PLAY Locked | Annual Yield | Voting Power | Fee Reduction |
|------|-------------|--------------|--------------|----------------|
| Bronze | 10,000 | 2% | 1.0x | None |
| Silver | 50,000 | 2% | 1.1x | 0.2% |
| Gold | 100,000 | 2.5% | 1.2x | 0.5% |
| Platinum | 250,000+ | 3% | 1.3x | 0.8% |

### Treasury Management Interface

```javascript
// Check node balance
const nodeBalance = await sdk.nodeOperator.getTreasuryBalance();
console.log(`Treasury: ${nodeBalance} $PLAY`);

// Stake additional tokens
await sdk.nodeOperator.stake({
  amount: 50000,
  duration: '1 year', // Lock-up period
  tier: 'gold'
});

// Claim annual yield
const yield = await sdk.nodeOperator.claimYield();
console.log(`Earned: ${yield} $PLAY`);

// Unstake (after lock-up expires)
await sdk.nodeOperator.unstake(50000);
```

### Slashing Penalties

| Violation | Penalty | Recovery |
|-----------|---------|----------|
| Downtime >4 hours | -0.5% of treasury | 30 days |
| Match result manipulation | -5% of treasury | 90 days |
| DDoS attack | -10% of treasury | 180 days + ban |
| Hosting illegal games | -100% of treasury | Permanent ban |

## 3. Revenue Sharing & Payouts

### Revenue Model (Per Match)

**Example:** $100 Wager Match

```
Gross Handle: $200 (both players wager $100)
Platform Rake (7%): $14.00

Distribution:
├─ Publisher: $4.00 (2%)
├─ Node Operator: $4.00 (2%)
├─ Treasury: $6.00 (3%)
└─ Burned (quarterly): $1.20 (20% of treasury)

Prize Pool (93%): $186.00
├─ Winner: $186.00
└─ Loser: $0.00
```

### Payout Schedule

- **Daily Settlements:** Payouts calculated nightly
- **Weekly Payout:** Every Monday, 8 AM UTC
- **Minimum Payout:** $50 (smaller venues paid monthly)
- **Payment Method:** Stablecoin (USDC) or $PLAY token

### Dashboard Analytics

Node operators access real-time stats:
- Total revenue generated this week/month
- Number of matches hosted
- Average wager per match
- Top games by revenue
- Player retention metrics
- Upcoming tournament payouts

## 4. Compliance & Legal Requirements

### KYC/AML Verification

Venue operators must verify:
- ✅ Business registration & tax ID
- ✅ Venue address & operational hours
- ✅ Owner identity & background check
- ✅ Gaming license (if required locally)
- ✅ Age verification system for cabinet access

### Responsible Gaming Compliance

- **Age Gates:** All cabinets require ID scan (18+)
- **Session Limits:** Player login shows account balance & limits
- **Deposit Caps:** Daily limits configurable by venue
- **Self-Exclusion:** Players can self-ban from venue for 30+ days
- **Warnings:** Display responsible gaming messages

### Record Keeping

Venues must maintain:
- Player session logs (12 months)
- Match results & payouts
- Compliance audit trails
- Incident reports (cheating, disputes)
- Regular backups of all data

## 5. Cabinet Maintenance & Support

### Regular Maintenance Schedule

| Task | Frequency | Duration |
|------|-----------|----------|
| Software updates | Weekly | 30 min |
| Hardware diagnostics | Monthly | 1 hour |
| Network stress test | Quarterly | 2 hours |
| Full security audit | Annually | 4 hours |

### Troubleshooting Guide

**Issue:** Cabinet loses connection to Node
- Solution: Check network cable; restart Node Server; verify firewall rules

**Issue:** Match result not settling
- Solution: Check internet connectivity; review Oracle logs; resubmit if <24hrs old

**Issue:** Player balance discrepancy
- Solution: Force sync with L2; check recent transactions; contact support if >$1000

### Support Channels

- **24/7 Hotline:** +1-800-SKILLWAGER
- **Discord Support:** discord.gg/skillwager-operators
- **Email:** support@skillwager.io
- **SLA:** <30 min response for critical issues

## 6. Marketing & Player Acquisition

### Co-Marketing Program

Skill Wager provides:
- Professional tournament graphics & posters
- Social media content calendar
- Email templates for player promotions
- Leaderboard displays for arcade walls

### Local Tournament Sponsorship

Host DAO-funded tournaments:
- Prize pools up to $5,000 per event
- Promotion via Skill Wager's marketing channels
- Live streaming support via Twitch integration
- Participant referral bonuses

### Player Onboarding Incentives

```
First-Time Player Bonus:
├─ Week 1: 20% deposit match (up to $50)
├─ 3 matches: +$10 bonus if playing >2 matches/week
├─ 10 matches: Unlock exclusive cosmetics
└─ 25 matches: Loyalty tier status
```

## 7. Security & Fraud Prevention

### Cabinet Security

- **Physical Locks:** Secure cabinet interior
- **Card Readers:** Players scan ID card to login
- **Session Timeouts:** Auto-logout after 30 mins inactivity
- **Audit Logging:** All actions recorded with timestamp

### Network Security

- **VPN Tunnel:** All data encrypted to Node Server
- **Firewall Rules:** Whitelist only Skill Wager IPs
- **DDoS Protection:** CloudFlare DDoS mitigation
- **Intrusion Detection:** Monitor suspicious access patterns

### Anti-Cheating Measures

- Match logs submitted to Oracle for verification
- Desync detection triggers automatic review
- Suspicious betting patterns flagged
- Serial number validation prevents spoofing

## 8. Performance Metrics

### Key Performance Indicators (KPIs)

- **Uptime:** Target 99.5%+ (500+ players)
- **Match Settlement:** <5 second average
- **Player Satisfaction:** Net Promoter Score >50
- **Revenue Retention:** >80% week-over-week

### Venue Dashboard

Operators see real-time:
- Active players on cabinets
- Revenue generated (current day/week/month)
- Top performing games
- Player loyalty scores
- Upcoming tournaments & events
