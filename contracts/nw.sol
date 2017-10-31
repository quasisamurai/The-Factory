pragma solidity ^0.4.13;

contract nw {

  address sender;
  event adr(address);


  function nw(){
    sender = msg.sender;
    adr(sender);
  }



}
