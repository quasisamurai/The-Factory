pragma solidity ^0.4.13;


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


contract network {
  function Register(address _owner, address _wallet, uint64 time) public returns(bool);
  function DeRegister(address _owner, address _wallet,  uint localR) public returns(bool);
  function getGlobalRate(address _owner, address _Profile) public returns (uint);
}


// Factory safe definition
contract factory{
    //Profile type
    enum TypeW {
    Hub,
    Client
    }

    mapping (address => address) public Profiles;
    mapping (address => TypeW) public types;

    function getProfile(address _owner) constant returns (address _Profile);
    function getType(address _Profile) constant returns (TypeW _type);
}
