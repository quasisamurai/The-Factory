pragma solidity ^0.4.4;

//Raw prototype for Hub wallet contract.


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


contract HubWallet is Ownable{




  ///@dev constructor
  function HubWallet(address _hubowner,address _dao,address _whitelist,token sharesAddress){
    owner=_hubowner;
    DAO=_dao;
    Whitelist=_whitelist;
    Factory=msg.sender;
    genesisTime=uint64(now);

    sharesTokenAddress = token(sharesAddress);

    //1 SNM token is needed to registrate in whitelist
    freezeQuote = 1 * (1 ether / 1 wei);

    // in the future this percent will be defined by factory.
    lockPercent= 30;

    //in promilles
    daoFee = 5;

    freezePeriod = 30 days;

  }


  /*/
   *  Constants
  /*/

  address public DAO;
  address public Factory;
  address public Whitelist;



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
  uint daoFee;


  modifier onlyDAO()     { if(msg.sender != DAO) throw; _; }



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

//  event LogBuy(address indexed owner, uint value);
//  event LogBurn(address indexed owner, uint value);
    event LogPhaseSwitch(Phase newPhase);



  /*/
   *  Public functions
  /*/

  function Registration() public onlyOwner returns (bool success){
    if(currentPhase != Phase.Created || currentPhase!=Phase.Idle) throw;
    if (sharesTokenAddress.balanceOf(msg.sender) <= freezeQuote) throw;
    frozenFunds=freezeQuote;
    frozenTime=uint64(now);
    //Appendix to call register function from Whitelist contract and check it.
    //
    currentPhase=Phase.Registred;
    return true;
  }

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

  function PayDay() public onlyOwner {

    if(currentPhase!=Phase.Registred) throw;

    if(now < (frozenTime + freezePeriod)) throw;

    //dao got's 0.5% in such terms.
    uint DaoCollect = lockedFunds * daoFee / 1000;

    sharesTokenAddress.transfer(DAO,DaoCollect);

    lockedFunds= 0;
    currentPhase=Phase.Idle;


  }


}
