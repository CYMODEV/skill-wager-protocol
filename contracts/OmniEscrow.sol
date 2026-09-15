// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

/**
 * @title Skill Wager OmniEscrow Protocol
 * @dev Handles L2 escrow locking, ECDSA signature verification from Venue Nodes,
 * and automated rake distribution for the Skill Wager network.
 */
contract OmniEscrow is Ownable, ReentrancyGuard {
    using ECDSA for bytes32;

    IERC20 public playToken;

    // Rake Distribution Parameters (in Basis Points. 10000 = 100%)
    uint256 public constant GROSS_RAKE_BPS = 700; // 7%
    uint256 public constant TREASURY_CUT_BPS = 300; // 3%
    uint256 public constant DEV_CUT_BPS = 200; // 2%
    uint256 public constant VENUE_CUT_BPS = 200; // 2%

    address public treasuryWallet;

    // Authorized Oracles (Venue Nodes)
    mapping(address => bool) public isAuthorizedNode;

    // Registry for Rake Routing
    mapping(bytes32 => address) public gameDevWallets; // GameHash -> DevWallet
    mapping(address => address) public venueWallets; // NodeAddress -> VenueOwnerWallet

    enum MatchState { OPEN, LOCKED, SETTLED, REFUNDED }

    struct Match {
        bytes32 gameHash;
        address player1;
        address player2;
        address venueNode;
        uint256 wagerAmount; // Amount PER PLAYER
        MatchState state;
    }

    mapping(bytes32 => Match) public matches;

    event MatchLocked(bytes32 indexed matchId, address indexed p1, address indexed p2, uint256 totalPool);
    event MatchSettled(bytes32 indexed matchId, address indexed winner, uint256 payout);
    event MatchRefunded(bytes32 indexed matchId, string reason);

    constructor(address _playToken, address _treasury) {
        playToken = IERC20(_playToken);
        treasuryWallet = _treasury;
    }

    // --- Core Match Mechanics ---

    function lockEscrow(
        bytes32 _matchId,
        bytes32 _gameHash,
        address _player1,
        address _player2,
        address _venueNode,
        uint256 _wagerAmount
    ) external nonReentrant {
        require(matches[_matchId].state == MatchState.OPEN, "Match ID already used");
        require(isAuthorizedNode[_venueNode], "Unauthorized Venue Node");
        require(_wagerAmount > 0, "Wager must be > 0");

        require(playToken.transferFrom(_player1, address(this), _wagerAmount), "P1 transfer failed");
        require(playToken.transferFrom(_player2, address(this), _wagerAmount), "P2 transfer failed");

        matches[_matchId] = Match({
            gameHash: _gameHash,
            player1: _player1,
            player2: _player2,
            venueNode: _venueNode,
            wagerAmount: _wagerAmount,
            state: MatchState.LOCKED
        });

        emit MatchLocked(_matchId, _player1, _player2, _wagerAmount * 2);
    }

    function settleMatch(
        bytes32 _matchId,
        address _winner,
        bytes memory _signature
    ) external nonReentrant {
        Match storage m = matches[_matchId];
        require(m.state == MatchState.LOCKED, "Match not locked");
        require(_winner == m.player1 || _winner == m.player2, "Invalid winner address");

        // Verify Signature from the authorized Venue Node
        bytes32 messageHash = keccak256(abi.encodePacked(_matchId, _winner));
        bytes32 ethSignedMessageHash = messageHash.toEthSignedMessageHash();
        address signer = ethSignedMessageHash.recover(_signature);
        require(signer == m.venueNode, "Invalid Oracle Signature");

        m.state = MatchState.SETTLED;

        uint256 totalPool = m.wagerAmount * 2;

        // Calculate and Route Rake
        uint256 treasuryCut = (totalPool * TREASURY_CUT_BPS) / 10000;
        uint256 devCut = (totalPool * DEV_CUT_BPS) / 10000;
        uint256 venueCut = (totalPool * VENUE_CUT_BPS) / 10000;

        playToken.transfer(treasuryWallet, treasuryCut);

        address devWallet = gameDevWallets[m.gameHash];
        if (devWallet != address(0)) playToken.transfer(devWallet, devCut);
        else playToken.transfer(treasuryWallet, devCut);

        address venueWallet = venueWallets[m.venueNode];
        if (venueWallet != address(0)) playToken.transfer(venueWallet, venueCut);
        else playToken.transfer(treasuryWallet, venueCut);

        // Route Payout
        uint256 payout = totalPool - (treasuryCut + devCut + venueCut);
        require(playToken.transfer(_winner, payout), "Payout transfer failed");

        emit MatchSettled(_matchId, _winner, payout);
    }
}