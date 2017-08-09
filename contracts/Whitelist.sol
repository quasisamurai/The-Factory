pragma solidity ^0.4.8;

//Whitelist prototype


//TODO: Correct internal structures


contract factory{

  //wallet type
  enum TypeW {
   Hub,
   Miner,
   Client
 }

  mapping (address => address) public wallets;
  mapping (address => TypeW) public types;

  function getWallet(address _owner) constant returns (address _wallet);
  function getType(address _wallet) constant returns (TypeW _type);

}



contract Whitelist{

  factory WalletsFactory;



  mapping (address => bool) public isRegistred;


/* TODO - make indexed events
*/
  event Registred(address _owner,address wallet, uint64 time, factory.TypeW _type);
  event unRegistred(address _owner,address wallet, uint64 time, factory.TypeW _type);



  //-----------------------------------func------------------------------------

  function Whitelist(factory Factory){

    WalletsFactory = factory(Factory);

  }


  function Register(address _owner, address _wallet, uint64 time) public returns(bool) {

    address wallet = WalletsFactory.getWallet(_owner);
    // Check that call comes from our wallet
    if (wallet!=msg.sender) throw;
    isRegistred[wallet]=true;

    factory.TypeW _type;
    _type=WalletsFactory.getType(_wallet);
    //Appendix event
    Registred(_owner,wallet,time,_type);
    return true;

  }




// General deregister
  function DeRegister(address _owner, address _wallet) public returns(bool) {

    address wallet = WalletsFactory.getWallet(_owner);
    // Check that call comes from our wallet
    if (wallet!=msg.sender) throw;
    isRegistred[wallet]=false;

    uint64 time;
    time=uint64(now);
    factory.TypeW _type;
    _type=WalletsFactory.getType(_wallet);
    //Appendix event
    unRegistred(_owner,wallet,time,_type);

    }



}
