# Proveably Random Raffle Contracts

## What we want it to do?
1. Users can enter by paying for a ticket
   1. The ticket fees are going to go to the winner during the draw
2. After X period of time, the lottery will automatically draw a winner
   1.  And this will be done programmatically
3. Using Chainlink VRF & Chainlink Automation
   1. Chainlink VRF -> Randomness
   2. Chainlink Automation -> Time based trigger

## Tests
1. Write some deploy scripts
2. Write some tests
   1. work on a local chian
   2. forked testnet
   3. forked mainnet