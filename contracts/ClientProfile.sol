pragma solidity ^0.4.10;

//Raw prototype for Client Profile contract.







import "./zeppelin/ownership/Ownable.sol";
//import "./Declaration.sol";
import "./Profile.sol";


contract ClientProfile is Ownable, Profile{




  ///@dev constructor
  function ClientProfile(address _Clientowner,address _dao,network _Network,token sharesAddress){
    owner=_Clientowner;
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

  function give(address _to, uint _value) public onlyOwner {


    if(currentPhase!=Phase.Registred) throw;
    sharesTokenAddress.approve(_to,value);
  }

  function transfer(address _to, uint _value) public onlyOwner {

    if(currentPhase!=Phase.Registred) throw;
    sharesTokenAddress.transfer(_to,value);

  }


  function pullMoney(address hubProfile) public onlyOwner{
    uint val = sharesTokenAddress.allowance(hubProfile,this);
    sharesTokenAddress.transferFrom(hubProfile,this,val);
    pulledMoney(hubProfile,val);
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
