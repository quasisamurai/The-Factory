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

  }

  mapping (uint => EscrowInfo) public deals;

}
