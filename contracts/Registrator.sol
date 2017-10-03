pragma solidity ^0.4.11;

// Desctiortion

//imports




// External calls



contract Registrator {

  // tyoe of entangle link
  enum TypeL {
    facebook,
    vk,
    github,
    email,
    telegram

  }

  TypeL public linktype;

  struct ProfileInfo {
    TypeL linktype;
    bytes32 link;
  }



//  mapping (address => linktype) public entangled;



}
