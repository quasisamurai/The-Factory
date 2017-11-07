pragma solidity ^0.4.13;


//Declaration contains declaretion of existed contracts and their functions


/* The token is used as a voting shares */
contract token {
    mapping (address => uint) public balances;

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);

    function transfer(address _to, uint _value) returns (bool success);

    function balanceOf(address _owner) constant returns (uint balance);

    function approve(address _spender, uint _value) returns (bool success);

    function allowance(address _owner, address _spender) constant returns (uint remaining);
}


contract network {
    function Register(address _owner, address _wallet, uint64 time) public returns (bool);

    function DeRegister(address _owner, address _wallet, uint localR) public returns (bool);

    function getGlobalRate(address _owner, address _Profile) public returns (uint);
}


// Factory safe definition
contract FactoryInterface {
    //Profile
    enum TypeW {
    Hub,
    Client
    }

    function getProfiles(address _owner) constant returns (address[] _Profile);

    function getType(address _Profile) constant returns (uint _type);
}


contract NetworkInterface {
    function GetProfiles(address owner) constant returns (address[]);

    function GetType(address profile) constant returns (uint);

    function GetGlobalRate() constant returns (uint);
}


contract ProfileInterface {
    function GetDeals() returns (uint[]);

    function GetRate() constant returns (uint[]);
}


contract DealInterface {
    function OpenDeal(address hub, address client, uint specificationHash, uint256 price, uint workTime, uint previousDealId) returns (uint);

    event DealOpened(address hub, address client, uint id);

    function AcceptDeal(uint id) returns (bool);

    event DealAccepted(address hub, address client, uint id);

    function CloseDeal(uint id) returns (bool);

    event DealClosed(address hub, address client, uint id);

    function GetDeals(address addr) constant returns (uint[]);

    function GetDealInfo(uint id) constant returns (address client, address hub, uint256 price, uint startTime, uint workTime, uint endTime, uint status);
}

