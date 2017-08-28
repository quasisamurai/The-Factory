pragma solidity ^0.4.11;

//Raw prototype for Client Profile contract.






import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
//import "./zeppelin/ownership/Ownable.sol";
//import "./Declaration.sol";
import "./Profile.sol";


contract ClientProfile is Ownable, Profile{




  ///@dev constructor
  function ClientProfile(address _clientowner,address _dao,network _Network,token sharesAddress){
    owner=_clientowner;
    DAO=_dao;
    Network= network(_Network);
    Factory=msg.sender;
    genesisTime=uint64(now);

    sharesTokenAddress = token(sharesAddress);

    //1 SNM token is needed to registrate in Network
    freezeQuote = 1 * (1 ether / 1 wei);

    // in the future this percent will be defined by factory.
    //lockPercent= 30;

    //in promilles
    // dao got's 1% in such terms.
    daoFee = 10;

    freezePeriod = 10 days;


    currentPhase = Phase.Idle;

  }



  /*/
   *  Public functions
  /*/

  function Registration() public returns (bool success){


      if(currentPhase!=Phase.Idle) revert();

    if (sharesTokenAddress.balanceOf(this) <= freezeQuote) revert();



    //Appendix to call register function from Network contract and check it.

    if(!super.CheckIn()) revert();
  //super.CheckIn();



    return true;
  }




}
