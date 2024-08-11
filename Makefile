-include .env

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80


all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"


# Update Dependencies
update:; forge update

install:; forge install OpenZeppelin/openzeppelin-contracts --no-commit && forge install Cyfrin/foundry-devops --no-commit

build:; forge build

test :; forge test 

.PHONY: all clean remove install update build test

snapshot :; forge snapshot

format :; forge fmt

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif

deploy:
	@forge script script/deploy.s.sol:DeployGamingNFt $(NETWORK_ARGS)


mint:
	@forge script script/interactions.s.sol:Interactions $(NETWORK_ARGS)


