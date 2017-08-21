pragma solidity ^0.4.11;

//Sonm social network contract
///@author Sergey Ponomarev




// Factory safe definition
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




// SONM social network
contract Network{

  factory ProfilesFactory;



  mapping (address => bool) public isRegistred;
  mapping (address => uint) public globalRate;


/* TODO - make indexed events
*/
  event Registred(address _owner,address Profile, uint64 time, factory.TypeW _type);
  event unRegistred(address _owner,address Profile, uint64 time, factory.TypeW _type);



  //-----------------------------------func------------------------------------

  function Network(factory Factory){

    ProfilesFactory = factory(Factory);

  }


  function Register(address _owner, address _Profile, uint64 time, uint localRate) public returns(bool) {

    address Profile = ProfilesFactory.getProfile(_owner);
    // Check that call comes from our Profile
    if (Profile!=msg.sender) revert();
    isRegistred[Profile]=true;

    factory.TypeW _type;
    _type=ProfilesFactory.getType(_Profile);

    if (globalRate[_Profile]==null){
    globalRate[_Profile]=localRate;
  } else {
    globalRate[_Profile]=globalRate[_Profile] + localRate;
  }

    //Appendix event
    Registred(_owner,Profile,time,_type);
    return true;

  }




// General deregister
  function DeRegister(address _owner, address _Profile) public returns(bool) {

    address Profile = ProfilesFactory.getProfile(_owner);
    // Check that call comes from our Profile
    if (Profile!=msg.sender) revert();
    isRegistred[Profile]=false;

    uint64 time;
    time=uint64(now);
    factory.TypeW _type;
    _type=ProfilesFactory.getType(_Profile);
    //Appendix event
    unRegistred(_owner,Profile,time,_type);

    }



}
