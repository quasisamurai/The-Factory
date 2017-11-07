pragma solidity ^0.4.11;


import 'zeppelin-solidity/contracts/token/StandardToken.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';


/*
 *  Sonm Dummy Token for test
 *
 *
 *
 * Very simple ERC20 Token example, where all tokens are pre-assigned
 * to the creator. Note they can later distribute these tokens
 * as they wish using `transfer` and other `StandardToken` functions.
 *
 *  simple standard
 */
contract SDT is StandardToken, Ownable {

    string public name = "Sonm Dummy Token";

    string public symbol = "SDT";

    uint public decimals = 18;

    uint public INITIAL_SUPPLY = 1000000 * 1 ether;

    function SDT() {
        totalSupply = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
    }


    function mintToken(address target, uint256 mintedAmount) onlyOwner {
        balances[target] += mintedAmount;
        totalSupply += mintedAmount;
        Transfer(0, owner, mintedAmount);
        Transfer(owner, target, mintedAmount);
    }

}
