default:
	truffle compile

migrate:
	truffle migrate

reset:
	truffle migrate --reset

test:
	truffle compile | truffle migrate --reset | truffle test
