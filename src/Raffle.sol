// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {VRFCoordinatorV2Interface} from "@chainlink/contracts@0.8.0/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts@0.8.0/src/v0.8/VRFConsumerBaseV2.sol";

/**
 * @title A sample Raffle Contract
 * @author Yuk1
 * @notice 
 * @dev Implements Chainlink VRFv2
 */
contract Raffle is VRFConsumerBaseV2 {
    error Raffle__NotEnoughEthSent();
    error Raffle__TranferFailed();
    error Raffle__NotOpen();

    enum RaffleState{
        OPEN,
        CLOSED,
        CALCULATING
    }

    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;

    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval; // in seconds
    uint256 private s_lastTimeStamp;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane;
    uint64 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;
    address private s_recentWinner;
    RaffleState private s_raffleState;

    address payable[] private s_players;
    

    event EnteredRaffle(address indexed player);
    event PickedWinner(address indexed winner);

    constructor(
        uint256 entranceFee, 
        uint256 interval, 
        uint256 timeStamp, 
        address vrfCoordinator, 
        bytes32 gasLane, 
        uint64 subscriptionId,
        uint32 callbackGasLimit
        ) VRFConsumerBaseV2(vrfCoordinator) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinator);
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;

        s_lastTimeStamp = timeStamp;
        s_raffleState = RaffleState.OPEN;
    }

    function enterRaffle() external payable {
        if(msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthSent();
        }
        if(s_raffleState != RaffleState.OPEN) {
            revert Raffle__NotOpen();
        }
        s_players.push(payable(msg.sender));
        emit EnteredRaffle(msg.sender);
    }

    function pickWinner() external {
        if(block.timestamp - s_lastTimeStamp < i_interval) {
            revert();
        }
        // 1. Request the RNG
        // https://docs.chain.link/vrf/v2/subscription/supported-networks
        s_raffleState = RaffleState.CALCULATING;
        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane, // gas lane
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );
        // 2. Get the random number
    }

    function fulfillRandomWords(
        uint256,
        uint256[] memory randomWord
    ) internal override {
        uint256 winnerIndex = randomWord[0] % s_players.length;
        s_recentWinner = s_players[winnerIndex];
        s_raffleState = RaffleState.OPEN;
        s_lastTimeStamp = block.timestamp;
        s_players = new address payable[](0);
        (bool success, ) = s_recentWinner.call{value: address(this).balance}("");
        if(!success) {
            revert Raffle__TranferFailed();
        }
        emit PickedWinner(s_recentWinner);
    }

    /** Getter Functions */
    function getEntranceFee() public view returns(uint256) {
        return i_entranceFee;
    }
}