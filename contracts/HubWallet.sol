pragma solidity ^0.4.4;

//Raw prototype for Hub wallet contract.


import "zeppelin/ownership/Ownable.sol";


/* The token is used as a voting shares */




contract token {
    mapping (address => uint) public balances;
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);

    function balanceOf(address _owner) constant returns (uint balance);
    function approve(address _spender, uint _value) returns (bool success);
    function allowance(address _owner, address _spender) constant returns (uint remaining);

}


contract HubWallet is Ownable{




  ///@dev constructor
  function HubWallet(address _hubowner,address _dao,address _whitelist){
    owner=_hubowner;
    DAO=_dao;
    Whitelist=_whitelist;
    Factory=msg.sender;


  }


  /*/
   *  Constants
  /*/

  address public DAO;
  address public Factory;
  address public Whitelist;


  //uint public freezePercent;

  // FreezeQuote - it is defined amount of tokens need to be frozen on  this contract.
  uint public freezeQuote;
  uint public frozenFunds;

  //lockedFunds - it is lockedFunds in percentage, which will be locked for every payday period.
  uint public lockPercent;
  uint public lockedFunds;

}
