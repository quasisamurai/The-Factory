pragma solidity ^0.4.11;

//sonm profile abstraction


import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
//import "./zeppelin/ownership/Ownable.sol";
//import "./Declaration.sol";
import "./Dealable.sol";



contract Profile  is Ownable, Dealable {



      /*/
       *  Constants
      /*/

      address public DAO;
      address public Factory;


      //address public Network;
      network Network;


      token public sharesTokenAddress;



      // FreezeQuote - it is defined amount of tokens need to be frozen on  this contract.
      uint public freezeQuote;


      //lockedFunds - it is lockedFunds in percentage, which will be locked for every payday period.
      //uint public lockPercent;
      uint public lockedFunds = 0;

      //TIMELOCK
      uint64 public frozenTime;
      uint public freezePeriod;
      uint64 public genesisTime;

      //Fee's
      uint daoFee;



      uint DaoCollect;

      uint public localRate = 0;
      uint public stake = 0;
      uint d_count = 0;



      modifier onlyDao()     { if(msg.sender != DAO) revert(); _; }



      /*/
       *  Profile state
      /*/

      enum Phase {
          Created,
          Registred,
          Idle,
          Suspected,
          Punished
      }


      Phase public currentPhase;


      /*/
       *  Events
      /*/


        event LogPhaseSwitch(Phase newPhase);
        event LogDebug(string message);




    /*/
     *  Public functions
    /*/


    // Deals-------------------------------------------------------------------

    function OpenDeal(uint cost) public returns (bool success){

      if(currentPhase!=Phase.Registred) revert();
      uint c = d_count;
      address _buyer = msg.sender;
      if (!super.start(c,cost,_buyer)) revert();
      d_count++;
      return true;

    }


    // Should it be onlyOwner?
    function getOpened() public returns (bool success, uint id){
      uint _id;
      DealStatus s = DealStatus.None;
      uint i=0;

        do{
          s = getStatus(i);
          _id = i;
          i++;
        }
        while(s!=DealStatus.Open || i<=d_count);



      if (s!=DealStatus.Open) {
        return (false,_id);
      } else {
      return (true, _id);
      }
    }

    //function AcceptDeal()


    //-------------------------------------------------------------------------

    //Register in Network
    function CheckIn() internal returns (bool success){

        // double check
        if(currentPhase!=Phase.Idle) revert();

      frozenTime=uint64(now);
      //Appendix to call register function from Network contract and check it.
      Network.Register(owner,this,frozenTime);

      currentPhase=Phase.Registred;
      LogPhaseSwitch(currentPhase);
      return true;
    }


    //DeRegister in Network
    function CheckOut() internal returns (bool success){


        //double check
        if(currentPhase!=Phase.Registred) revert();

        // Comment it for test usage.
      if(now < (frozenTime + freezePeriod)) revert();

      //Appendix to call register function from Network contract and check it.
      Network.DeRegister(owner,this,localRate);

      currentPhase=Phase.Idle;
      LogPhaseSwitch(currentPhase);
      return true;
    }


    // RATINGS --------------------------------------------------------------

    function plusRate(uint amount) internal returns (bool success){

        localRate += amount;
        return true;
        }

    function minusRate(uint amount) internal returns (bool success){
        localRate -= amount;
        return true;
        }

    function getRate() public returns (uint localR){
      uint r=localRate;
      return r;
      }


    // Stake is a temprary value of tokens, which owner could hold on his accounts
    // Stake has influence to the total score
    function putStake(uint amount) public onlyOwner {
      if(currentPhase!=Phase.Registred) revert();
      uint lock = lockedFunds + amount;

      if(sharesTokenAddress.balanceOf(msg.sender)< (lock)) revert();

      uint l = stake + lock;
      uint s = stake + amount;
      stake = s;
      lockedFunds = l;
    }

    function takeStake() internal {
      // double chek of state here, may been improved
      if(currentPhase!=Phase.Registred) revert();
      uint l = lockedFunds;
      lockedFunds = l - stake;
      stake = 0;
    }


    function buyRate(uint amount) public onlyOwner {

      if(currentPhase!=Phase.Registred) revert();

      uint g = Network.getGlobalRate(owner,this);
      // Check this with intence in test stage
      uint p = g / 100;
      // Rates cannot be increased more than for 10% at one buy.
      p = p * 10;

      if (amount > p) revert();
      uint lock = lockedFunds + amount;

      if(sharesTokenAddress.balanceOf(msg.sender)< (lock)) revert();

      lockedFunds = lock;
      if(!plusRate(amount)) revert();

    }



//------TOKEN ITERACTION-------------------------------------------------------

    function transfer(address _to, uint _value) public onlyOwner {

      if(currentPhase!=Phase.Registred) revert();

          uint lockFee = _value * daoFee / 1000;
          uint lock = lockedFunds + lockFee;
          uint value=_value - lockFee;
          if(sharesTokenAddress.balanceOf(msg.sender)< (lock + value)) revert();
          lockedFunds=lock;
          sharesTokenAddress.transfer(_to,value);

    }

    //Otobrat i podelit
    function give(address _to, uint _value) public onlyOwner {


      if(currentPhase!=Phase.Registred) revert();

          uint lockFee = _value * daoFee / 1000;
          uint lock = lockedFunds + lockFee;
          uint value=_value - lockFee;

          if(sharesTokenAddress.balanceOf(msg.sender)< (lock + value)) revert();

          lockedFunds=lock;
          sharesTokenAddress.approve(_to,value);
    }

    function pullMoney(address Profile) public{
      if(currentPhase!=Phase.Registred) revert();
      uint val = sharesTokenAddress.allowance(Profile,this);
      sharesTokenAddress.transferFrom(Profile,this,val);

    }

//------------------------------------------------------------------------------
      function PayDay() public onlyOwner {

        if(currentPhase!=Phase.Registred) revert();

        takeStake();

        //uint balance = sharesTokenAddress.balanceOf(msg.sender);

        // !CONCEPTUAL
        // should we take a fee from turn?
        //  uint turn = balance * daoFee / 1000;
        DaoCollect = lockedFunds;
        //DaoCollect = DaoCollect + turn;
        lockedFunds= 0;

        // Comment it if you gonna run tests.
        if(now < (frozenTime + freezePeriod)) revert();



        //dao got's 0.5% in such terms.
          sharesTokenAddress.transfer(DAO,DaoCollect);
          if (!CheckOut()) revert();

      }

    function withdraw(address to, uint amount) public onlyOwner {

      if(currentPhase!=Phase.Idle) revert();
      sharesTokenAddress.transfer(to,amount);
    }



    function suspect() public onlyDao {
      if (currentPhase!=Phase.Registred) revert();

      frozenTime = uint64(now);
      currentPhase = Phase.Suspected;
      LogPhaseSwitch(currentPhase);
      freezePeriod = 120 days;
     CheckOut();
    }

    function gulag() public onlyDao {
      if (currentPhase!=Phase.Suspected) revert();
      if (now < (frozenTime + freezePeriod)) revert();
      lockedFunds=sharesTokenAddress.balanceOf(this);
      uint amount = lockedFunds + stake;
      sharesTokenAddress.transfer(DAO,amount);
      currentPhase = Phase.Punished;
      LogPhaseSwitch(currentPhase);

    }

    function rehub() public onlyDao {
      if (currentPhase!=Phase.Suspected) revert();
      lockedFunds = 0;
      currentPhase = Phase.Idle;
      LogPhaseSwitch(currentPhase);
    }


  }
