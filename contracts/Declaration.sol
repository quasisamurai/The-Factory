pragma solidity ^0.4.4;

//Declaration contains declaretion of existed contracts and their functions



/* The token is used as a voting shares */
contract token {
    mapping (address => uint) public balances;
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
    function transfer(address _to, uint _value) returns (bool success);
    function balanceOf(address _owner) constant returns (uint balance);
    function approve(address _spender, uint _value) returns (bool success);
    function allowance(address _owner, address _spender) constant returns (uint remaining);

}




contract whitelist {



  function RegisterHub(address _owner, address wallet, uint64 time) public returns(bool);
  function RegisterMin(address _owner, address wallet, uint64 time) public returns(bool);

  function DeRegister(address _owner, address _wallet) public returns(bool);
//  mapping (address => HubInfo) public Registred;
}

contract Declaration {

}
