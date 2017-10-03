pragma solidity ^0.4.11;

// Desctiortion

//imports




// External calls



contract Registrator {

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
    bytes64 fcb;
    bytes64 vk;
    bytes64 git;
    bytes64 eml;
    bytes64 tlgr;
  }



  mapping (address => SocLinks) public entangled;



}
