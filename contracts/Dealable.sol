pragma solidity ^0.4.11;

//import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import "./Declaration.sol";

contract Dealable{



  enum DealStatus {
    //  Delayed,
      Open,
      Accepted,
      Cancelled,
      Rejected,
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
      bool delayed;

  }

  uint d_count = 0;

  mapping (uint => DealInfo) public deals;
  mapping (address => bool) public buyers;


  function start(uint _lockId, uint _amount, address _buyer) internal {



      //create default Deal struct or access existing
      DealInfo memory info = deals[_lockId];

      //lock only once for a given id
      if(info.lockedFunds > 0) revert();

    //  if(info.status != Available) throw;
      // buyer init  deal.
      info.buyer = _buyer;
      info.lockedFunds = _amount;
      info.status = DealStatus.Open;



    //  pendingCount += _count;

      buyers[msg.sender] = true;
      //Start order to event log
      /* TODO make events for this
      */
    //  LogEvent(_lockId, _dataInfo, _version, Start, msg.sender, msg.value);
  }

  function accept(uint _lockId) internal {

      DealInfo memory info = deals[_lockId];
      if(info.status != DealStatus.Open) revert();
      info.status = DealStatus.Accepted;

  // Here is could be rule for auto-accept or auto-throw


  //Accept order to event log
    //  LogEvent(_lockId, _dataInfo, _version, Accept, msg.sender, info.lockedFunds);
  }

  function reject(uint _lockId) internal {

      DealInfo memory info = deals[_lockId];
      if(info.status != DealStatus.Open) revert();
      info.status = DealStatus.Rejected;

  // Here is could be rule for auto-accept or auto-throw


  //Accept order to event log
    //  LogEvent(_lockId, _dataInfo, _version, Accept, msg.sender, info.lockedFunds);
  }

  function cancel(uint _lockId) internal {

      DealInfo memory info = deals[_lockId];
      if(info.status != DealStatus.Open) revert();
      info.status = DealStatus.Cancelled;

  // Here is could be rule for auto-accept or auto-throw


  //Accept order to event log
    //  LogEvent(_lockId, _dataInfo, _version, Accept, msg.sender, info.lockedFunds);
  }



}
