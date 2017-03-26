pragma solidity ^0.4.4;

//Raw prototype for Hub wallet contract.


import "zeppelin/ownership/Ownable.sol";


/* The token is used as a voting shares */




contract token {
    mapping (address => uint) public balances;
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);

    function balanceOf(address _owner) constant returns (uint balance);
}


contract HubWallet{




  ///@dev constructor
  function HubWallet(){



  }


  /*/
   *  Constants
  /*/

  uint public freezePercent;
  uint public frozenFunds;




}
