#!/bin/bash

TRUFFLE=./node_modules/truffle/build/cli.bundled.js
TESTRPC=./node_modules/ethereumjs-testrpc/build/cli.node.js

GAS_LIMIT=10000000

node_modules:
	npm install

migrate: node_modules
	rm -rf ./build
	nohup ${TESTRPC} -l ${GAS_LIMIT} &
	${TRUFFLE} migrate


#test:
#	truffle compile | truffle migrate --reset | truffle test

#test: $(GO_BUILDS) node_modules
#	@echo "+ $@"
#	TESTRPC="$(shell pwd)/${TESTRPC}" ${GO} test ./tests