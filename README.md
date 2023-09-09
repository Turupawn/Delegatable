![test workflow](https://github.com/Turupawn/Delegatable/actions/workflows/test.yml/badge.svg)

# Delegatable Contract

Smart contract that is able to cast votes coming from a delegate account.

## Running the test

The testing script creates a proposal in the Velodrome Governor contract on Optimism Mainnet and a delegate cast a vote through the delegatable contract.

```bash
forge test --fork-url https://mainnet.optimism.io
```