pragma solidity ^0.4.8;

//Whitelist prototype

//TODO: README
//TODO: Phase renewal in struct.
//TODO: Approved (whited) wallets mapping

contract factory{
  mapping (address => bool) public hubs;
  mapping (address => bool) public miners;
  function check(address _hubwallet) public returns(bool);
  function checkM(address _minwallet) public returns(bool);
  function HownerOf(address _wallet) constant returns (address _owner);
  function MownerOf(address _wallet) constant returns (address _owner);
}


contract Whitelist{

  factory WalletsFactory;

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


  event RegistredHub(address indexed _owner,address wallet, uint64 indexed time);
  event RegistredMiner(address indexed _owner,address wallet, uint64 indexed time, uint indexed stake);


  function Whitelist(factory Factory){

    WalletsFactory = factory(Factory);

  }

  function RegisterHub(address _owner, address wallet, uint64 time) public returns(bool) {



    address owner = WalletsFactory.HownerOf(msg.sender);
    if (owner!=_owner) throw;

    HubInfo info = RegistredHubs[wallet];
    info.owner=_owner;
    //Time is money!
    info.RegTime=time;

    RegistredHub(_owner,wallet,time);
    return true;

  }

  function RegisterMin(address _owner, address wallet, uint64 time, uint stakeShare) public returns(bool) {



    address owner = WalletsFactory.MownerOf(msg.sender);
    if (owner!=_owner) throw;

    MinerInfo info = RegistredMiners[wallet];
    info.owner=_owner;
    //Time is money!
    info.RegTime=time;

    info.stake=stakeShare;

    RegistredMiner(_owner,wallet,time,stakeShare);
    return true;

  }

  function WhoIsH(address hub) constant returns (HubInfo Info){
    return RegistredHubs[hub];
  }

  function WhoIsM(address miner) constant returns (MinerInfo Info){
    return RegistredMiners[miner];
  }

}
