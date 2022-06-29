#!/bin/bash

export DIR_NAME=
export CONTRACT_NAME=

beaker new $DIR_NAME
cd $DIR_NAME
beaker wasm new $CONTRACT_NAME

