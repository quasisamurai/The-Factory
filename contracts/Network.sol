pragma solidity ^0.4.13;


//Sonm social network contract
///@author Sergey Ponomarev


import './Declaration.sol';


// SONM social network
contract Network {

    factory ProfilesFactory;

    mapping (address => bool) public isRegistred;

    mapping (address => uint) public globalRate;


    /* TODO - make indexed events
    */
    event Registred(address _owner, address Profile, uint64 time, factory.TypeW _type);

    event unRegistred(address _owner, address Profile, uint64 time, factory.TypeW _type, uint Diff);



    //-----------------------------------func------------------------------------

    function Network(factory Factory){

        ProfilesFactory = factory(Factory);

    }


    function Register(address _owner, address _Profile, uint64 time) public returns (bool) {

        address Profile = ProfilesFactory.getProfile(_owner);
        // Check that call comes from our Profile
        require(Profile == msg.sender);
        isRegistred[Profile] = true;

        factory.TypeW _type;
        _type = ProfilesFactory.getType(_Profile);
        /*
            if (globalRate[_Profile]==null){
              globalRate[_Profile]=0;
            }
            */

        //Appendix event
        Registred(_owner, Profile, time, _type);
        return true;
    }

    function DeRegister(address _owner, address _Profile, uint localR) public returns (bool) {

        address Profile = ProfilesFactory.getProfile(_owner);
        // Check that call comes from our Profile
        require(Profile == msg.sender);
        isRegistred[Profile] = false;

        uint64 time;
        time = uint64(now);
        factory.TypeW _type;
        _type = ProfilesFactory.getType(_Profile);

        uint g = globalRate[_Profile];
        uint diff = g - localR;
        globalRate[_Profile] = g + localR;

        //Appendix event
        unRegistred(_owner, Profile, time, _type, diff);

    }

    function getGlobalRate(address _owner, address _Profile) public returns (uint) {
        address Profile = ProfilesFactory.getProfile(_owner);
        // Check that call comes from our Profile
        require(Profile == msg.sender);
        uint g = globalRate[_Profile];
        return g;
    }

}
