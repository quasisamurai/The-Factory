pragma solidity ^0.4.11;

/* This contract is added only for debug.
Sure, we shouldnt multiply weird code to delete after debug
Some modifies for debug arrived.



!!!!
DELETE AFTER DEBUG
!!!!!!
*/


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;
  event LogDebug(string message);
  event DebugAddress(address lookup);

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    if (msg.sender != owner) {
      LogDebug("msg.sender!= owner");
      DebugAddress(msg.sender);
      DebugAddress(owner);
      revert();
  }
   _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) onlyOwner {
    if (newOwner != address(0)) {
      owner = newOwner;
    }
  }

}
