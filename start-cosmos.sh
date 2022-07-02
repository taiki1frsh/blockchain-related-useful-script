#!/bin/bash

export DAEMON=
export DENOM=
export STAKE_DENOM=

rm -fr ~/.$DAEMON;

$DAEMON init --chain-id test test;

$DAEMON keys add val;
$DAEMON keys add usr;
$DAEMON keys add usr2;

$DAEMON add-genesis-account $($DAEMON keys show -a val) 1000000000$DENOM, 1000000000$STAKE_DENOM;
$DAEMON add-genesis-account $($DAEMON keys show -a usr) 1000000000$DENOM;
$DAEMON add-genesis-account $($DAEMON keys show -a usr2) 1000000000$DENOM;
$DAEMON gentx validator 100000000$STAKE_DENOM --chain-id=test;
$DAEMON collect-gentxs;
$DAEMON start;


