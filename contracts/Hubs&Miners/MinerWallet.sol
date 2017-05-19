pragma solidity ^0.4.4;

//Raw prototype for Hub wallet contract.

// TODO: Punishment function - Done but not cheked
// TODO: Structure - done
// TODO: README - Done
// TODO: Registred Appendix
// TODO: Whitelist;





import "zeppelin/ownership/Ownable.sol";


/* The token is used as a voting shares */
contract token {
    mapping (address => uint) public balances;
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
    function transfer(address _to, uint _value) returns (bool success);
    function balanceOf(address _owner) constant returns (uint balance);
    function approve(address _spender, uint _value) returns (bool success);
    function allowance(address _owner, address _spender) constant returns (uint remaining);

}


contract whitelist {

  function Register(address _owner, address wallet, uint64 time) public returns(bool);
//  mapping (address => HubInfo) public Registred;
}



contract MinerWallet is Ownable{




  ///@dev constructor
  function MinerWallet(address _minowner,address _dao,whitelist _whitelist,token sharesAddress){
    owner=_minowner;
    DAO=_dao;
    Whitelist= whitelist(_whitelist);
    Factory=msg.sender;
    genesisTime=uint64(now);

    sharesTokenAddress = token(sharesAddress);

    //1 SNM token is needed to registrate in whitelist
    freezeQuote = 1 * (1 ether / 1 wei);

    // in the future this percent will be defined by factory.
    lockPercent= 30;

    //in promilles
    daoFee = 5;

    // time of work period.
    freezePeriod = 14 days;

  }


  /*/
   *  Constants
  /*/

  address public DAO;
  address public Factory;


  //address public Whitelist;
  whitelist Whitelist;


  token public sharesTokenAddress;


  //uint public freezePercent;

  // FreezeQuote - it is defined amount of tokens need to be frozen on  this contract.
  uint public freezeQuote;
  uint public frozenFunds;

  //lockedFunds - it is lockedFunds in percentage, which will be locked for every payday period.
  uint public lockPercent;
  uint public lockedFunds = 0;

  //TIMELOCK
  uint64 public frozenTime;
  uint public freezePeriod;
  uint64 public genesisTime;

  //Fee's
//  uint daoFee;


  modifier onlyDao()     { if(msg.sender != DAO) throw; _; }



  /*/
   *  Wallet state
  /*/

  enum Phase {
      Created,
      Registred,
      Idle,
      Suspected,
      Punished
  }

  Phase public currentPhase = Phase.Created;

  /*/
   *  Events
  /*/


    event LogPhaseSwitch(Phase newPhase);
    event pulledMoney(address hub, uint amount);



  /*/
   *  Public functions
  /*/

  function Registration(uint stake) public onlyOwner returns (bool success){
    if(currentPhase != Phase.Created || currentPhase!=Phase.Idle) throw;
    if (sharesTokenAddress.balanceOf(msg.sender) <= freezeQuote) throw;

    frozenFunds=stake+freezeQuote;
    frozenTime=uint64(now);
    //Appendix to call register function from Whitelist contract and check it.
    // TODO add to register function frozenFunds record.
    Whitelist.Register(owner,this,frozenTime);
    currentPhase=Phase.Registred;
    LogPhaseSwitch(currentPhase);
    return true;
  }

  function pullMoney(address hubwallet) public onlyOwner{
    uint val = sharesTokenAddress.allowance(hubwallet,this);
    sharesTokenAddress.transferFrom(hubwallet,this,val);
    pulledMoney(hubwallet,val);
  }


/*
  function transfer(address _to, uint _value) public onlyOwner{
    if(currentPhase!=Phase.Registred) throw;

    uint lockFee = _value * lockPercent / 100;
    uint lock = lockedFunds + lockFee;
    uint limit = lock + frozenFunds;

    uint value=_value - lockFee;

    if(sharesTokenAddress.balanceOf(msg.sender)< (limit + value)) throw;

    lockedFunds=lock;

    sharesTokenAddress.approve(_to,value);

  }
*/


  function PayDay() public onlyOwner {

    if(currentPhase!=Phase.Registred) throw;

    if(now < (frozenTime + freezePeriod)) throw;

    //dao got's 0.5% in such terms.
    uint DaoCollect = lockedFunds * daoFee / 1000;
    DaoCollect = DaoCollect + frozenFunds;
    frozenFunds = 0;

    sharesTokenAddress.transfer(DAO,DaoCollect);

    lockedFunds= 0;
    currentPhase=Phase.Idle;
    LogPhaseSwitch(currentPhase);


  }

  function withdraw() public onlyOwner {

    if(currentPhase != Phase.Created || currentPhase!=Phase.Idle) throw;
    uint amount = sharesTokenAddress.balanceOf(this);
    sharesTokenAddress.transfer(owner,amount);

  }

  function suspect() public onlyDao {
    if (currentPhase!=Phase.Registred) throw;
//    frozenFunds = 0;
    lockedFunds=sharesTokenAddress.balanceOf(this);
    frozenTime = uint64(now);
    currentPhase = Phase.Suspected;
    LogPhaseSwitch(currentPhase);
    freezePeriod = 120 days;
  }

  function gulag() public onlyDao {
    if (currentPhase!=Phase.Suspected) throw;
    if (now < (frozenTime + freezePeriod)) throw;
    uint amount = lockedFunds;
    sharesTokenAddress.transfer(DAO,amount);
    currentPhase = Phase.Punished;
    LogPhaseSwitch(currentPhase);

  }

  function rehub() public onlyDao {
    if (currentPhase!=Phase.Suspected) throw;
    lockedFunds = 0;
    frozenFunds = 0;

    currentPhase = Phase.Idle;
    LogPhaseSwitch(currentPhase);
  }


}
