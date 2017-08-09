pragma solidity ^0.4.8;


//Raw prototype of wallet factory


//TODO - DOCS


import './HubWallet.sol';
import './MinerWallet.sol';



contract Factory {

    token sharesTokenAddress;

    address dao;

    whitelist Whitelist;

    //wallet type
    enum TypeW {
     Hub,
     Miner,
     Client
   }

  TypeW public walletType;


    // owner => wallet
    mapping (address => address) public wallets;

    //wallet types
    // wallet => type
    mapping (address => TypeW) public types;

    //Type of hubs.
    // wallet => type. true for private pools (clusters, datacentres, etc)
    mapping (address => bool) public privat;


    event LogCreate(address wallet, address owner);

    event LogCr(address owner);
    //  event Weird(string thing);

    function Factory(token TokenAddress, address _dao){
        sharesTokenAddress = TokenAddress;
        dao = _dao;
    }

    modifier onlyDao(){
        if (msg.sender != dao) throw;
        _;
    }

    function changeAdresses(address _dao, whitelist _whitelist) public onlyDao {
        dao = _dao;
        Whitelist = whitelist(_whitelist);
    }



    function createHub(bool _privat) public returns (address) {
        address _hubowner = msg.sender;
        address hubwallet = createH(_hubowner,_privat);
        wallets[_hubowner] = hubwallet;
        types[hubwallet] = TypeW.Hub;
        privat[hubwallet] = _privat;
        LogCreate(hubwallet, _hubowner);
    }

    function createMiner() public returns (address) {
        address _minowner = msg.sender;
        address minwallet = createM(_minowner);
        wallets[_minowner] = minwallet;
        types[_minowner] = TypeW.Miner;
        LogCreate(minwallet, _minowner);
    }

    function createH(address _hubowner, bool _privat) private returns (address) {
        return address(new HubWallet(_hubowner, dao, Whitelist, sharesTokenAddress,_privat));
        LogCr(_hubowner);
    }

    function createM(address _minowner) private returns (address) {
        return address(new MinerWallet(_minowner, dao, Whitelist, sharesTokenAddress));
        LogCr(_minowner);
    }


    function getWallet(address _owner) constant returns (address _wallet) {
        return wallets[_owner];
    }

    function getType(address _wallet) constant returns (TypeW _type) {
        return types[_wallet];
    }

    function isPrivate(address _wallet) constant returns (bool _private) {
        return privat[_wallet];
    }

}
