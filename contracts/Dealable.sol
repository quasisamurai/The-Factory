pragma solidity ^0.4.13;

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

    // TODO - events

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
    uint startTime;
    uint endTime;
    uint withdrawedFunds;
    // Next one for delay deals function.
    //  bool delayed;
  }



  mapping (uint => DealInfo) public deals;
  mapping (address => bool) public buyers;



  function start(uint _lockId, uint _amount, address _buyer, uint _endTime) internal returns (bool success){
    //create default Deal struct or access existing
    DealInfo memory info = deals[_lockId];
    //lock only once for a given id
    //require(info.lockedFunds > 0);
    info.buyer = _buyer;
    info.lockedFunds = _amount;
    info.status = DealStatus.Open;
    info.startTime = block.timestamp;
    info.endTime = _endTime;
    info.withdrawedFunds = 0;
    buyers[_buyer] = true;
    deals[_lockId] = info;

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

  function getCost(uint _lockId) public returns (uint cost){
    DealInfo memory info = getInfo(_lockId);
    uint _cost = info.lockedFunds;
    return _cost;
  }

  function getBuyer(uint _lockId) public returns (address buyer){
    DealInfo memory info = getInfo(_lockId);
    address _buyer = info.buyer;
    return _buyer;
  }

  function getStartTime(uint _lockId) public returns (uint startTime){
    DealInfo memory info = getInfo(_lockId);
    uint _startTime = info.startTime;
    return _startTime;
  }

  function getEndTime(uint _lockId) public returns (uint endTime){
    DealInfo memory info = getInfo(_lockId);
    uint _endTime = info.endTime;
    return _endTime;
  }

  function getWithdrawedFunds(uint _lockId) public returns (uint withdrawedFunds){
    DealInfo memory info = getInfo(_lockId);
    uint _withdrawedFunds = info.withdrawedFunds;
    return _withdrawedFunds;
  }

  function updateWithdrawedFunds(uint _lockId, uint _amount) internal returns (uint){
    DealInfo memory info = getInfo(_lockId);
    info.withdrawedFunds+=_amount;
    return info.withdrawedFunds;
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
    require(info.status == DealStatus.Open);
    //require(info.buyer==_buyer);
    info.status = DealStatus.Cancelled;
    deals[_lockId] = info;
    return true;
  }

  //Abort deal which already running
  function abort(uint _lockId,address _buyer) internal returns (bool success){
    DealInfo memory info = deals[_lockId];
    require(info.status == DealStatus.Accepted);
    require(info.buyer==_buyer);
    info.status = DealStatus.Aborted;
    deals[_lockId] = info;
    return true;
  }


  function ready(uint _lockId) internal returns (bool success){
    DealInfo memory info = deals[_lockId];
    require(info.status == DealStatus.Accepted);
    info.status = DealStatus.Ready;
    deals[_lockId] = info;
    return true;
  }

  function done(uint _lockId,address _buyer) internal returns (bool success){
    DealInfo memory info = deals[_lockId];
    require(info.status == DealStatus.Ready);
    require(info.buyer==_buyer);
    info.status = DealStatus.Done;
    deals[_lockId] = info;
    return true;
  }


  function hardDone(uint _lockId) internal returns (bool success){
    DealInfo memory info = deals[_lockId];
    require(info.status == DealStatus.Ready);
    info.status = DealStatus.Done;
    deals[_lockId] = info;
    return true;
  }

  function appeal(uint _lockId,address _buyer) internal returns (bool success){

    DealInfo memory info = deals[_lockId];
    require(info.status == DealStatus.Ready);
    require(info.buyer==_buyer);
    info.status = DealStatus.Aborted;
    deals[_lockId] = info;
    return true;
  }

}
