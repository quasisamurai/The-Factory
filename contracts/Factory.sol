pragma solidity ^0.4.13;


//Raw prototype of Profile MEGAFACTORY
//TODO - DOCS

import './Declaration.sol';


contract FactoryH{
  function createH(address _hubowner, address dao, address Sonm, address sharesTokenAddress) public returns (address);
}

contract FactoryC{
  function createC(address _clientowner, address dao, address Sonm, address sharesTokenAddress) public returns (address);
}


contract Factory is factory {

    token sharesTokenAddress;
    address dao;
    address Sonm;
    FactoryH hf;
    FactoryC cf;
    TypeW public ProfileType;


    // owner => Profile
    mapping (address => address) public Profiles;

    //Profile types
    // Profile => type
    mapping (address => TypeW) public types;

    event LogCreate(address Profile, address owner);

    event LogCr(address owner);
    event LogDebug(string message);
    event DebugAddress(address lookup);
    event Acceptance1(address owner, address dao, address Sonm, address token);
    address fish = 0x0;

    function Factory(token TokenAddress, FactoryH _hf, FactoryC _cf){
        sharesTokenAddress = TokenAddress;
        dao = msg.sender;
        hf = _hf;
        cf = _cf;
    }

    modifier onlyDao(){
        if (msg.sender != dao) {
        LogDebug("msg.sender!= dao");
        DebugAddress(msg.sender);
        DebugAddress(dao);
        revert();
      }
        _;
    }

    function changeAdresses(address _dao, address _Sonm) public onlyDao {
        //network _Sonm
        dao = _dao;
        Sonm = _Sonm;
    }



    function createHub() public returns (address) {
        require(Sonm != fish);
        address _hubowner = msg.sender;
        Acceptance1(_hubowner,dao,Sonm, sharesTokenAddress);
        address hubProfile = hf.createH(_hubowner, dao, Sonm, sharesTokenAddress);
        Profiles[_hubowner] = hubProfile;
        types[hubProfile] = TypeW.Hub;
        LogCreate(hubProfile, _hubowner);
    }

    function createClient() public returns (address) {
      require(Sonm != fish);
      address _clientowner = msg.sender;
      address clientProfile = cf.createC(_clientowner, dao, Sonm, sharesTokenAddress);
      Profiles[_clientowner] = clientProfile;
      types[clientProfile] = TypeW.Client;
      LogCreate(clientProfile, _clientowner);
    }

    function getProfile(address _owner) constant returns (address _Profile) {
        if (Profiles[_owner]==0) LogDebug("Address has not have profile!");
        return Profiles[_owner];
    }

    function getType(address _Profile) constant returns (TypeW _type) {
        return types[_Profile];
    }
}
