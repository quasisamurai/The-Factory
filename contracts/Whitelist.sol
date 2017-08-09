pragma solidity ^0.4.8;

//Whitelist prototype


//TODO: Correct internal structures


contract factory{
  mapping (address => address) public hubs;
  mapping (address => address) public miners;
  function HubOf(address _owner) constant returns (address _wallet);
  function MinerOf(address _owner) constant returns (address _wallet);
}

contract Wallet{


  enum TypeW {
   Hub,
   Miner,
   Client
 }

 TypeW public walletType;

 function getType() public returns (TypeW){
   TypeW r=walletType;
   return r;
 }
}

contract Whitelist{

  factory WalletsFactory;

/*

  struct HubInfo {

    address owner;
    uint64 RegTime;

    // Probably we need to register and renew Phase of wallet as well.

  }


  struct MinerInfo {

    address owner;
    uint64 RegTime;
    uint stake;


  }



  mapping (address => HubInfo) public RegistredHubs;
  mapping (address => MinerInfo) public RegistredMiners;
*/

  mapping (address => bool) public RegistredHubs;
  mapping (address => bool) public RegistredMiners;

  event RegistredHub(address indexed _owner,address wallet, uint64 indexed time);
  event RegistredMiner(address indexed _owner,address wallet, uint64 indexed time);

/* TODO - fix enum conversion issue?
  ISSUE - type enum cannot be implicity convertible to expected type bool
  PATCH - will use uint type as temporal solution?
*/
/*
  enum TypeW {
   Hub,
   Miner,
   Client
 }
*/

  //uint h=1;

  //-----------------------------------func------------------------------------

  function Whitelist(factory Factory){

    WalletsFactory = factory(Factory);

  }

/*
    TODO make incapculation for general Register function
*/
  function RegisterHub(address _owner, address _wallet, uint64 time) public returns(bool) {

    address wallet = WalletsFactory.HubOf(_owner);
    if (wallet!=msg.sender) throw;


    /*
    HubInfo info = RegistredHubs[wallet];
    info.owner=_owner;
    //Time is money!
    info.RegTime=time;
    */

    RegistredHubs[wallet]= true;

    RegistredHub(_owner,wallet,time);
    return true;

  }

  function RegisterMin(address _owner, address _wallet, uint64 time) public returns(bool) {

    address wallet = WalletsFactory.MinerOf(_owner);
    if (wallet!=msg.sender) throw;



    /*
    MinerInfo info = RegistredMiners[wallet];
    info.owner=_owner;
    //Time is money!
    info.RegTime=time;

    info.stake=stakeShare;
    */

    RegistredMiners[wallet] = true;

    RegistredMiner(_owner,wallet,time);
    return true;

  }

  //TODO - incapsulate Registration

  function UnRegisterHub(address _owner, address _wallet) private returns(bool) {



    RegistredHubs[_wallet]= false;
  }

  function UnRegisterMiner(address _owner, address _wallet) private returns(bool) {


    RegistredMiners[_wallet]= false;
  }

// General deregister
  function DeRegister(address _owner, address _wallet) public returns(bool) {

    Wallet.TypeW _type;
    _type = Wallet.getType();

    if (_type==Wallet.TypeW.Hub) {
      address wallet_h = WalletsFactory.HubOf(_owner);
      if (wallet_h!=msg.sender) throw;
      UnRegisterHub(_owner,_wallet);
    }

    if (_type==Wallet.TypeW.Miner) {
      address wallet_m = WalletsFactory.MinerOf(_owner);
      if (wallet_m!=msg.sender) throw;
      UnRegisterMiner(_owner,_wallet);
    }

    // Add unregister client func?
  }

}
