pragma solidity ^0.4.4;

//Raw prototype for Hub wallet contract.


/* The token is used as a voting shares */
contract token { mapping (address => uint) public balances;  }

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
