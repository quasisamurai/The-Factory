pragma solidity ^0.4.8;

//Whitelist prototype

//TODO: README
//TODO: Correct internal structures


contract factory{
  mapping (address => address) public hubs;
  mapping (address => address) public miners;
  function HubOf(address _owner) constant returns (address _wallet);
  function MinerOf(address _owner) constant returns (address _wallet);
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

 enum Type {
   Hub,
   Miner,
   Client
 }



  //-----------------------------------func------------------------------------

  function Whitelist(factory Factory){

    WalletsFactory = factory(Factory);

  }

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

  function UnRegisterHub(address _owner, address _wallet) public returns(bool) {

    address wallet = WalletsFactory.HubOf(_owner);
    if (wallet!=msg.sender) throw;

    RegistredHubs[wallet]= false;
  }

  function UnRegisterMiner(address _owner, address _wallet) public returns(bool) {
    address wallet = WalletsFactory.MinerOf(_owner);
    if (wallet!=msg.sender) throw;

    RegistredMiners[wallet]= false;
  }

// General deregister
  function DeRegister(Type _type, address _owner, address _wallet) public returns(bool) {

  }

}
