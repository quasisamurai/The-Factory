pragma solidity ^0.4.8;

//sonm profile abstraction



import "./zeppelin/ownership/Ownable.sol";
import "./Declaration.sol";



contract Profile  is Ownable {



      /*/
       *  Constants
      /*/

      address public DAO;
      address public Factory;
//

      //address public Network;
      network Network;


      token public sharesTokenAddress;



      // FreezeQuote - it is defined amount of tokens need to be frozen on  this contract.
      uint public freezeQuote;


      //lockedFunds - it is lockedFunds in percentage, which will be locked for every payday period.
      uint public lockPercent;
      uint public lockedFunds = 0;

      //TIMELOCK
      uint64 public frozenTime;
      uint public freezePeriod;
      uint64 public genesisTime;

      //Fee's
      uint daoFee;



      uint DaoCollect;

      uint localRate;


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


      Phase public currentPhase;


      /*/
       *  Events
      /*/


        event LogPhaseSwitch(Phase newPhase);




    /*/
     *  Public functions
    /*/






    //Register in Network
    function CheckIn() public returns (bool success){
        if(msg.sender!=address(this)) throw;
        // double check
        if(currentPhase!=Phase.Idle) throw;

      frozenTime=uint64(now);
      //Appendix to call register function from Network contract and check it.
      Network.Register(owner,this,frozenTime);

      currentPhase=Phase.Registred;
      LogPhaseSwitch(currentPhase);
      return true;
    }


    //DeRegister in Network
    function CheckOut() public returns (bool success){

        if(msg.sender!=address(this)) throw;
        //double check
        if(currentPhase!=Phase.Registred) throw;

        // Comment it for test.
      if(now < (frozenTime + freezePeriod)) throw;

      //Appendix to call register function from Network contract and check it.
      Network.DeRegister(owner,this);

      currentPhase=Phase.Idle;
      LogPhaseSwitch(currentPhase);
      return true;
    }

    function transfer(address _to, uint _value) public onlyOwner {

      if(currentPhase!=Phase.Registred) throw;

          uint lockFee = _value * daoFee / 1000;
          uint lock = lockedFunds + lockFee;
          uint value=_value - lockFee;
          if(sharesTokenAddress.balanceOf(msg.sender)< (lock + value)) throw;
          lockedFunds=lock;
          sharesTokenAddress.transfer(_to,value);

    }

    //Otobrat i podelit
    function give(address _to, uint _value) public onlyOwner {


      if(currentPhase!=Phase.Registred) throw;

          uint lockFee = _value * lockPercent / 100;
          uint lock = lockedFunds + lockFee;
          uint value=_value - lockFee;

          if(sharesTokenAddress.balanceOf(msg.sender)< (lock + value)) throw;

          lockedFunds=lock;
          sharesTokenAddress.approve(_to,value);
    }

    function pullMoney(address Profile) public{
      if(currentPhase!=Phase.Registred) throw;
      uint val = sharesTokenAddress.allowance(Profile,this);
      sharesTokenAddress.transferFrom(Profile,this,val);

    }

      function buyRate(uint amount) public onlyOwner {

        if(currentPhase!=Phase.Registred) throw;
        uint lock = lockedFunds;

        if(sharesTokenAddress.balanceOf(msg.sender)< (lock)) throw;

        lockedFunds = lockedFunds + amount;
        localRate = localRate + amount;

      }


      function PayDay() public onlyOwner {

        if(currentPhase!=Phase.Registred) throw;

        uint balance = sharesTokenAddress.balanceOf(msg.sender);
        uint turn = balance * daoFee / 1000;
        DaoCollect = lockedFunds * daoFee / 1000;
        DaoCollect = DaoCollect + turn;
        lockedFunds= 0;

        // Comment it for test.
        if(now < (frozenTime + freezePeriod)) throw;

        //For test usage
      //  DaoCollect=0;

        //dao got's 0.5% in such terms.
          sharesTokenAddress.transfer(DAO,DaoCollect);
          if (!CheckOut()) throw;

      }

    function withdraw(address to, uint amount) public onlyOwner {

      if(currentPhase!=Phase.Idle) throw;
    //  uint amount = sharesTokenAddress.balanceOf(this);
      sharesTokenAddress.transfer(to,amount);
    }



    function suspect() public  {
      if (currentPhase!=Phase.Registred) throw;
      lockedFunds=sharesTokenAddress.balanceOf(this);
      frozenTime = uint64(now);
      currentPhase = Phase.Suspected;
      LogPhaseSwitch(currentPhase);
      freezePeriod = 120 days;
     CheckOut();
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
      currentPhase = Phase.Idle;
      LogPhaseSwitch(currentPhase);
    }


  }
