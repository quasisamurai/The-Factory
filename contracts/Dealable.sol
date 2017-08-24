pragma solidity ^0.4.11;

//import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import "./Declaration.sol";

contract Dealable{



  enum DealStatus {
    //  Delayed,
      None,
      Open,
      Accepted,
      Cancelled,
      Rejected,
      Aborted,
      Ready,
      Done
  }

  /*

    WARN - pay attention to the type of the struct.
    regarding this - https://ethereum.stackexchange.com/questions/21420/storage-warning-in-solidity
    we need to point what type of storage do we point is. If the struct is using as a persistent storage
    it should be point as 'storage'. If the struct is using only for the inside-cycle of function and should not be
    persistent use 'memory'

    Also there is a compilator bug with warnings about this ^^^ issue and for fix it we need to upgrade compilator
    version of all contracts to 0.4.14 or higher.

  */
  struct  DealInfo  {

      address  buyer;
      uint lockedFunds;
      DealStatus status;
      // Next one for delay deals function.
    //  bool delayed;

  }



  mapping (uint => DealInfo) public deals;
  mapping (address => bool) public buyers;



  function start(uint _lockId, uint _amount, address _buyer) internal returns (bool success){
      //create default Deal struct or access existing
      DealInfo storage info = deals[_lockId];

      //lock only once for a given id
      if(info.lockedFunds > 0) revert();

    //  if(info.status != Available) throw;
      // buyer init  deal.
      info.buyer = _buyer;
      info.lockedFunds = _amount;
      info.status = DealStatus.Open;

      buyers[_buyer] = true;
      //Start order to event log
      /* TODO make events for this
      */
    //  LogEvent(_lockId, _dataInfo, _version, Start, msg.sender, msg.value);


    return true;
  }

  function getInfo(uint _lockId) internal returns (DealInfo info){

    DealInfo memory _info = deals[_lockId];
    return _info;
  }

  function getStatus(uint _lockId) public returns (DealStatus status){
    DealInfo memory _info = getInfo(_lockId);
//    DealInfo memory info = deals[_lockId];
    DealStatus  _status = _info.status;
    return _status;

  }

  function accept(uint _lockId) internal returns (bool success){

      DealInfo memory info = deals[_lockId];

      require(info.status == DealStatus.Open);
      info.status = DealStatus.Accepted;
      deals[_lockId] = info;

    return true;
  }

  function reject(uint _lockId) internal returns (bool success){

      DealInfo memory info = deals[_lockId];
      require(info.status == DealStatus.Open);
      info.status = DealStatus.Rejected;
      deals[_lockId] = info;

    return true;
  }


  function cancel(uint _lockId,address _buyer) internal returns (bool success){

      DealInfo memory info = deals[_lockId];
      if(info.status != DealStatus.Open) revert();
      require(info.buyer==_buyer);
      info.status = DealStatus.Cancelled;
      deals[_lockId] = info;

    return true;
  }

  //Abort deal which already running
  function abort(uint _lockId,address _buyer) internal returns (bool success){

          DealInfo memory info = deals[_lockId];
          if(info.status != DealStatus.Accepted) revert();
          require(info.buyer==_buyer);
          info.status = DealStatus.Aborted;
          deals[_lockId] = info;

        return true;
  }

/*
  function ready(uint _lockId) internal returns (bool success){
    DealInfo storage info = deals[_lockId];
    if(info.status != DealStatus.Accepted) revert();

  }
*/

}
