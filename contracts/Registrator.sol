pragma solidity ^0.4.11;

// Desctiortion

//imports




// External calls

contract factory {

function getProfile(address _owner) constant returns (address _Profile);

}


contract Registrator {

  factory ProfilesFactory;


  // KonstrUktor
  function Registrator(address Factory){
    ProfilesFactory = factory(Factory);
  }

  /*
  // tyoe of entangle link
  enum TypeL {
    facebook,
    vk,
    github,
    email,
    telegram
  }
  */




  struct SocLinks {
    bytes32 fcb;
    bytes32 vk;
    bytes32 git;
    bytes32 eml;
    bytes32 tlgr;
  }

//  TypeL public linktype

  mapping (address => SocLinks) public entangled;

  /* NOTE I should notice, that we cannot simply use array of links cause every link is bytes32 array itself.

    Also I should NOTE, that this contract should be deployed from us (and not from user) + it should be cheap in use for user, so
    I think we need to write it in style with many different fuctions. So we can avoid unaccecary chek.

  */


  function facebook (bytes32 link) public returns (bool success) {

    //Appendix for Profile address getter
    address profile = ProfilesFactory.getProfile(msg.sender);

  //  address profile = msg.sender;


    SocLinks memory links = entangled[profile];
    links.fcb = link;
    return true;


  }



}
