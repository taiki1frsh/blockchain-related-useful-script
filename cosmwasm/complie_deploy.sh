#!/bin/bash

# First source .env file to set env variables

# compile stuff

# In case to produce much smaller .wasm file
RUSTFLAGS='-C link-arg=-s'

RUST_BACKTRACE=1

# optimize to reduce code size. need docker installed for arm cpu.
# and single contract
docker run --rm -v "$(pwd)":/code \
  --mount type=volume,source="$(basename "$(pwd)")_cache",target=/code/target \
  --mount type=volume,source=registry_cache,target=/usr/local/cargo/registry \
  cosmwasm/rust-optimizer-arm64:0.12.6
  
# incase multi contracts
docker run --rm -v "$(pwd)":/code \
  --mount type=volume,source="$(basename "$(pwd)")_cache",target=/code/target \
  --mount type=volume,source=registry_cache,target=/usr/local/cargo/registry \
  cosmwasm/workspace-optimizer-arm64:0.12.6


# store and instantiate struff

# see the list of codes was uploaded to the target network
# $DAEMON query wasm list-code $NODE

# store bytecode and acquire code id of it
RES=$($DAEMON tx wasm store artifacts/$CONTRACT_NAME.wasm --from $STORER  $TXFLAG -y --output json -b block)
CODE_ID=$(echo $RES | jq -r '.logs[0].events[-1].attributes[0].value')
echo $CODE_ID

# instantiate contract out of the uploaded code using that code id
# write instance state in josn 
INIT='{}'

$DAEMON tx wasm instantiate $CODE_ID "$INIT" --from $INSTANTIATER --label $LABEL $TXFLAG -y --no-admin

# See the contract details
$DAEMON query wasm contract $CONTRACT $NODE
# Check the contract balance
$DAEMON query bank balances $CONTRACT $NODE
# Query the entire contract state
wasmd query wasm contract-state all $CONTRACT $NODE
