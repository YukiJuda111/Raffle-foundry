# Proveably Random Raffle Contracts

## Quick Start
`make install` to install the dependencies
`make build` to compile the contract
`make  deploy` to deploy the contract on sopelia network using your own private key

## Usage of Raffle
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