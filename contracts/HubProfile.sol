pragma solidity ^0.4.8;

//Raw prototype for Hub Profile contract.







import "./zeppelin/ownership/Ownable.sol";
//import "./Declaration.sol";
import "./Profile.sol";


contract HubProfile is Ownable, Profile{


  bool privat = false;

  ///@dev constructor
  function HubProfile(address _hubowner,address _dao,network _Network,token sharesAddress, bool _privat){
    owner=_hubowner;
    DAO=_dao;
    Network= network(_Network);
    Factory=msg.sender;
    genesisTime=uint64(now);

    sharesTokenAddress = token(sharesAddress);

    //1 SNM token is needed to registrate in Network
    freezeQuote = 1 * (1 ether / 1 wei);

    // in the future this percent will be defined by factory.
    lockPercent= 30;

    //in promilles
    daoFee = 5;

    freezePeriod = 10 days;


      privat=_privat;


    currentPhase = Phase.Idle;

  }



  /*/
   *  Public functions
  /*/

  function Registration() public returns (bool success){


      if(currentPhase!=Phase.Idle) throw;

    if (sharesTokenAddress.balanceOf(this) <= freezeQuote) throw;

    frozenFunds=freezeQuote;

    //Appendix to call register function from Network contract and check it.

    if(!super.CheckIn()) throw;
  //super.CheckIn();



    return true;
  }

  function transfer(address _to, uint _value) public onlyOwner {

    // Transfer function (from hub to miner) is able only for 'public' hubs
    if(privat = true) throw;

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
  //  if (daoflag!=true) throw;

    DaoCollect = lockedFunds * daoFee / 1000;
    DaoCollect = DaoCollect + frozenFunds;
    frozenFunds = 0;
    lockedFunds= 0;

    // Comment it for test.
    if(now < (frozenTime + freezePeriod)) throw;

    //For test usage
  //  DaoCollect=0;

    //dao got's 0.5% in such terms.
      sharesTokenAddress.transfer(DAO,DaoCollect);
      if (!super.CheckOut()) throw;

  }

}
