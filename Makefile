-include .env

.PHONY: all test deploy install build help

help:
	@echo "Please use 'make <target>' where <target> is one of"
	@echo "  all       to build, install, test and deploy"
	@echo "  build     to build the project"
	@echo "  install   to install the project"
	@echo "  test      to test the project"
	@echo "  deploy    to deploy the project"

build:
	forge build

install:
	forge install transmissions11/solmate --no-commit
	forge install Cyfrin/foundry-devops --no-commit   
	forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit

test:
	forge test

deploy:
	forge script script/DeployRaffle.s.sol:DeployRaffle $(NETWORK_ARGS) --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify src/Raffle.sol:Raffle --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
