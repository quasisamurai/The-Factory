pragma solidity ^0.4.11;

//import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import "./Declaration.sol";

contract Dealable{



  enum DealStatus {
      Aviable,
      Open,
      Accepted,
      Cancelled,
      Rejected,
      Done

  }

  struct DealInfo {

      address buyer;
      uint lockedFunds;
      DealStatus status;

  }

  uint d_count = 0;

  mapping (uint => DealInfo) public deals;
  mapping (address => bool) public buyers;


  function start(uint _lockId, string _dataInfo, uint _amount, address _buyer) internal {



      //create default EscrowInfo struct or access existing
      DealInfo info = deals[_lockId];

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

      DealInfo info = deals[_lockId];
      if(info.status != DealStatus.Open) revert();
      info.status = DealStatus.Accepted;

  // Here is could be rule for auto-accept or auto-throw


  //Accept order to event log
    //  LogEvent(_lockId, _dataInfo, _version, Accept, msg.sender, info.lockedFunds);
  }

  function reject(uint _lockId) internal {

      DealInfo info = deals[_lockId];
      if(info.status != DealStatus.Open) revert();
      info.status = DealStatus.Rejected;

  // Here is could be rule for auto-accept or auto-throw


  //Accept order to event log
    //  LogEvent(_lockId, _dataInfo, _version, Accept, msg.sender, info.lockedFunds);
  }

  function cancel(uint _lockId) internal {

      DealInfo info = deals[_lockId];
      if(info.status != DealStatus.Open) revert();
      info.status = DealStatus.Cancelled;

  // Here is could be rule for auto-accept or auto-throw


  //Accept order to event log
    //  LogEvent(_lockId, _dataInfo, _version, Accept, msg.sender, info.lockedFunds);
  }



}
