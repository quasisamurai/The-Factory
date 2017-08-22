pragma solidity ^0.4.11;

import "./Declaration.sol";

contract Dealable{



  enum DealStatus {
      None,
      Aviable,
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

  mapping (uint => EscrowInfo) public deals;


  function start(uint _lockId, string _dataInfo, uint _version) payable {

      //reject money transfers for bad status

      if(status != Available) throw;

      if(feePromille > 1000) throw;
      if(rewardPromille > 1000) throw;
      if((feePromille + rewardPromille) > 1000) throw;

      //create default EscrowInfo struct or access existing
      EscrowInfo info = escrows[_lockId];

      //lock only once for a given id
      if(info.lockedFunds > 0) throw;

      //lock funds

      uint fee = (msg.value * feePromille) / 1000;
      //limit fees
      if(fee > msg.value) throw;

      uint funds = (msg.value - fee);
      feeFunds += fee;
      totalEscrows += 1;

      // buyer init escrow deal.
      info.buyer = msg.sender;
      info.lockedFunds = funds;
      info.frozenFunds = 0;
      info.buyerNo = false;
      info.sellerNo = false;


    //  pendingCount += _count;
      buyers[msg.sender] = true;

      //Start order to event log
      LogEvent(_lockId, _dataInfo, _version, Start, msg.sender, msg.value);
  }

}
