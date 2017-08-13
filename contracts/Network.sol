pragma solidity ^0.4.8;

//Sonm social network contract
///@author Sergey Ponomarev





contract factory{

  //Profile type
  enum TypeW {
   Hub,
   Miner,
   Client
 }

  mapping (address => address) public Profiles;
  mapping (address => TypeW) public types;

  function getProfile(address _owner) constant returns (address _Profile);
  function getType(address _Profile) constant returns (TypeW _type);

}



contract Network{

  factory ProfilesFactory;



  mapping (address => bool) public isRegistred;


/* TODO - make indexed events
*/
  event Registred(address _owner,address Profile, uint64 time, factory.TypeW _type);
  event unRegistred(address _owner,address Profile, uint64 time, factory.TypeW _type);



  //-----------------------------------func------------------------------------

  function Network(factory Factory){

    ProfilesFactory = factory(Factory);

  }


  function Register(address _owner, address _Profile, uint64 time) public returns(bool) {

    address Profile = ProfilesFactory.getProfile(_owner);
    // Check that call comes from our Profile
    if (Profile!=msg.sender) throw;
    isRegistred[Profile]=true;

    factory.TypeW _type;
    _type=ProfilesFactory.getType(_Profile);
    //Appendix event
    Registred(_owner,Profile,time,_type);
    return true;

  }




// General deregister
  function DeRegister(address _owner, address _Profile) public returns(bool) {

    address Profile = ProfilesFactory.getProfile(_owner);
    // Check that call comes from our Profile
    if (Profile!=msg.sender) throw;
    isRegistred[Profile]=false;

    uint64 time;
    time=uint64(now);
    factory.TypeW _type;
    _type=ProfilesFactory.getType(_Profile);
    //Appendix event
    unRegistred(_owner,Profile,time,_type);

    }



}
