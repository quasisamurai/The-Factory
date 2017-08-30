pragma solidity ^0.4.11;

//Raw prototype for Miner Profile contract.


import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import "./Profile.sol";


contract MinerProfile is Ownable, Profile{

  ///@dev constructor
  function MinerProfile(address _minowner,address _dao,network _Network,token sharesAddress){
    owner=_minowner;
    DAO=_dao;
    Network= network(_Network);
    Factory=msg.sender;
    genesisTime=uint64(now);
    sharesTokenAddress = token(sharesAddress);

    //1 SNM token is needed to registrate in Network
    freezeQuote = 1 * (1 ether / 1 wei);

    //in promilles
    daoFee = 5;
    // time of work period.
    freezePeriod = 10 days;

  }



  function Registration() public onlyOwner returns (bool success){
    require(currentPhase==Phase.Idle);
    require(sharesTokenAddress.balanceOf(this) >= freezeQuote);

    if(!super.CheckIn()) revert();

    return true;
  }



}
