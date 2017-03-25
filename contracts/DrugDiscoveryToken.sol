pragma solidity ^0.4.4;


import "zeppelin/token/StandardToken.sol";


/*
 * SimpleToken
 *
 * Very simple ERC20 Token example, where all tokens are pre-assigned
 * to the creator. Note they can later distribute these tokens
 * as they wish using `transfer` and other `StandardToken` functions.
 */
contract DrugDiscoveryToken is StandardToken {

  string public name = "DrugDiscoveryToken";
  string public symbol = "DDT";
  uint public decimals = 18;
  uint public INITIAL_SUPPLY = 1000000 * 1 ether;

  function DrugDiscoveryToken() {
    totalSupply = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
  }

}
