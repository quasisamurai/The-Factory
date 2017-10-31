pragma solidity^0.4.13;


import './nw.sol';

contract creator {

  event LogAddress(address);

  function rep() public returns (address){

    return address(new nw());

    //address newContr = address(new nw());
    //LogAddress(newContr);
    //return newContr;

  }

/*
  function rep() public returns (address){
    address newContr = create();
    LogAddress(newContr);
    return newContr;

  }
*/


}
