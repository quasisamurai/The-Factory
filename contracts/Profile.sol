pragma solidity ^0.4.14;

//sonm profile abstraction


//import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
// ^ uncomment this after debug
import "./Ownable.sol";
//import "./SDT.sol";
import "./Dealable.sol";
import "./Declaration.sol";




contract Profile is Ownable, Dealable {

      /*/
       *  Constants
      /*/


/*
      // FreezeQuote - it is defined amount of tokens need to be frozen on  this contract.
      // TODO - remove this
      //uint public freezeQuote;


      //lockedFunds - it is lockedFunds in percentage, which will be locked for every payday period.
      //uint public lockPercent;


      //TIMELOCK

      uint64 public frozenTime;
      uint public freezePeriod;
      uint64 public genesisTime;



      uint public localRate = 0;
      uint public stake = 0;
      */
      //Fee's
      uint daoFee;
      uint DaoCollect;

      address public DAO;
      address public Factory;
      //address public Network;
      address Network;
      bool public isHub;
      address public sharesTokenAddress;
      uint deals_count = 0;
      uint public lockedFunds = 0;
      address owner;

      //adress of seller(for client profile)/ buyer (for hub profile) =>  lockid
      mapping (address => uint[]) mydeals;

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
      event DebugAddress(address lookup);
      event DealOpened(address buyer, address seller, uint cost, uint lockid);
      event DealAccepted(address buyer, address seller, uint cost, uint lockid);
      event DealAborted(address buyer, address seller, uint cost, uint lockid);
      event DealCanceled(address buyer, address seller, uint cost, uint lockid);
      event DealRejected(address buyer, address seller, uint cost, uint lockid);
      event DealIsReady(address buyer, address seller, uint cost, uint lockid);
      event DealIsDone(address buyer, address seller, uint cost, uint lockid);
      event DealAppealed(address buyer, address selle, uint cost, uint lockid);

    // constructor

    function Profile(address _profileowner, address _dao, address Sonm, address _sharesTokenAddress, bool _isHub){
      owner = _profileowner;
      DAO = _dao;
      Network = Sonm;
      sharesTokenAddress = _sharesTokenAddress;
      isHub = _isHub;
    }

    modifier onlyHub(){require (isHub==true); _;}
    modifier onlyClient(){require(isHub==false); _;}

    function OpenExternalDeal(address _sellerAddress,uint cost, uint _endTime) public onlyOwner onlyClient returns (bool success){
      //  id of concrete deal
      uint id;
      Profile seller = Profile(_sellerAddress);
      require(token(sharesTokenAddress).approve(_sellerAddress, cost)) ;
      id = seller.OpenDeal(cost, _endTime);
      mydeals[_sellerAddress].push(id);
      deals_count++;
      return true;
      }


    function GetDeals(address _contragentAddress) constant returns (uint256[]){
      return mydeals[_contragentAddress];
    }

    // Deals-------------------------------------------------------------------

    function OpenDeal(uint cost, uint _endTime) external returns (uint lockId){
      DebugAddress(this);
      //require(currentPhase==Phase.Registred);
      lockId= deals_count;
      address _buyer = msg.sender;
      require(super.start(lockId,cost,_buyer, _endTime));
      pullMoney(_buyer);
      lockedFunds+=cost;
      mydeals[_buyer].push(lockId);
      deals_count++;
      DealOpened(msg.sender, this, cost, lockId);
      return lockId;
    }

    function CancelDeal(uint _lockId) public returns (bool success) {
      DebugAddress(this);
      require(currentPhase==Phase.Registred);
      require(super.cancel(_lockId,msg.sender));
      uint cost = super.getCost(_lockId);
      DealCanceled(msg.sender, this, cost, _lockId);
      return true;
    }

    function AbortDeal(uint _lockId) public returns (bool success) {
      DebugAddress(this);
      require(currentPhase==Phase.Registred);
      require(super.abort(_lockId,msg.sender));
      lockedFunds-=cost;
      uint cost = super.getCost(_lockId);
      //address buyer = super.getBuyer(_lockId);
      transfer(msg.sender, cost);
      DealAborted(msg.sender, this, cost, _lockId);
      return true;
    }

    function AcceptDeal(uint _lockId) public onlyOwner onlyHub returns (bool success){
      DebugAddress(this);
      require(currentPhase==Phase.Registred);
      require(super.accept(_lockId));
      uint cost = super.getCost(_lockId);
      address buyer = super.getBuyer(_lockId);
      DealAccepted(buyer, msg.sender, cost, _lockId);
      return true;
    }

    function RejectDeal(uint _lockId) public onlyOwner returns (bool success) {
      require(currentPhase==Phase.Registred);
      require(super.reject(_lockId));
      uint cost = super.getCost(_lockId);
      address buyer = super.getBuyer(_lockId);
      transfer(buyer, cost);
      DealRejected(buyer, msg.sender, cost, _lockId);
      return true;
    }


    function ReadyDeal(uint _lockId) public onlyOwner returns (bool success) {
      require(currentPhase==Phase.Registred);
      require(super.ready(_lockId));
      uint cost = super.getCost(_lockId);
      address buyer = super.getBuyer(_lockId);
      DealIsReady(buyer, msg.sender, cost, _lockId);
      return true;
    }

    function DoneDeal(uint _lockId) public onlyClient  returns (bool success) {
      require(currentPhase==Phase.Registred);
      uint cost = super.getCost(_lockId);
      //uint lockFee = cost * daoFee / 1000;
      lockedFunds -= cost;
      //DaoCollect += lockFee;
      //require(plusRate(cost));
      require(super.done(_lockId,msg.sender));
      PaymentWithdraw(_lockId);
      DealIsDone(msg.sender, this, cost, _lockId);
      return true;
    }

    function Donehard(uint _lockId) internal returns (bool success){
      uint cost = super.getCost(_lockId);
      uint lockFee = cost * daoFee / 1000;
      lockedFunds -= cost;
      DaoCollect += lockFee;
      //require(plusRate(cost));
      require(super.hardDone(_lockId));
      return true;

    }

    function AppealDeal(uint _lockId) public returns (bool success) {
      require(currentPhase==Phase.Registred);
      uint cost = super.getCost(_lockId);
      uint lockFee = cost * daoFee / 1000;
      lockedFunds -= cost;
      DaoCollect += lockFee;
      require(super.appeal(_lockId,msg.sender));
      //require(minusRate(cost));
      DealAppealed(msg.sender, this, cost, _lockId);
      return true;
    }

    // hub receives funds, in proportion to time worked
    function PayAsYouGo(uint _lockId, address _whom) public onlyOwner returns (bool success){
      uint nowTime = block.timestamp;
      uint cost = super.getCost(_lockId);
      uint endTime = super.getEndTime(_lockId);
      uint startTime = super.getStartTime(_lockId);
      uint withdrawedAmount = super.getWithdrawedFunds(_lockId);
      //pps is the price per second;
      uint pps = cost / (endTime - startTime);
      uint withdrawAmount = (nowTime - startTime) * pps - withdrawedAmount;
      lockedFunds-=withdrawAmount;
      require(transfer(_whom, withdrawAmount));
      updateWithdrawedFunds(_lockId, withdrawAmount);
      return true;
    }

    // unlock funds that hub should get. then, he can pull money whatever he wants by PAYG
    function PaymentWithdraw(uint _lockId) internal onlyClient returns (bool success){
      require(msg.sender == super.getBuyer(_lockId));
      uint nowTime = block.timestamp;
      uint cost = super.getCost(_lockId);
      uint endTime = super.getEndTime(_lockId);
      uint startTime = super.getStartTime(_lockId);
      uint withdrawedAmount = super.getWithdrawedFunds(_lockId);
      uint pps = cost / (endTime - startTime);
      uint finalWithdraw = pps * (nowTime - startTime) - withdrawedAmount;
      lockedFunds -= finalWithdraw;
      return true;
    }

/*

I DUNNO WHY THIS IS STILL HERE
    // Should it be onlyOwner?
    // NOTICE - this and next functions are actually call functions, which returns data
    // from smart-contract, but does not change the state, therefore it is not consume gas
    function getOpened() public returns (bool success, uint id){
      require(currentPhase==Phase.Registred);
      uint _id;
      DealStatus s = DealStatus.None;
      uint i=0;

        do{
          s = super.getStatus(i);
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

    function getAccepted() public returns (bool success, uint id){
      uint _id;
      DealStatus s = DealStatus.None;
      uint i=0;

        do{
          s = super.getStatus(i);
          _id = i;
          i++;
        }
        while(s!=DealStatus.Accepted || i<=d_count);

      if (s!=DealStatus.Accepted) {
        return (false,_id);
      } else {
      return (true, _id);
      }
    }

    function getReady() public returns (bool sucess, uint id){
      uint _id;
      DealStatus s = DealStatus.None;
      uint i=0;

        do{
          s = super.getStatus(i);
          _id = i;
          i++;
        }
        while(s!=DealStatus.Ready || i<=d_count);

      if (s!=DealStatus.Accepted) {
        return (false,_id);
      } else {
      return (true, _id);
      }

    }

    function checkAccepted() public returns (bool flag){
      var(a,b) = getAccepted();
      if (a==true){
        LogDebug("You have non ready but accepted deals!");
      }
      return a;
    }

    function checkReady() public returns (bool flag){
      var(a,b) = getReady();
      if (a==true){
        LogDebug("You have non closed but ready deals!");
      }
      return a;
    }

   This function close all ready but not accepted by buyer deals
    function hodor() public onlyOwner returns (bool success){
        require(currentPhase==Phase.Registred);
        require(now >= (frozenTime + freezePeriod));
        require(checkReady() == true);
        do {
          var(a,b) = getReady();
          require(Donehard(b) == true);
        }
        while(checkReady() == true);
        return true;
    }

*/
    //-------------------------------------------------------------------------

/*    //Register in Network
    function CheckIn() internal returns (bool success){

        // double check
        require(currentPhase==Phase.Idle);

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
        require(currentPhase==Phase.Registred);
        bool accepted = checkAccepted();
        require(accepted == false);
        bool ready = checkReady();
        require(ready == false);

        // Comment it for test usage.
      require(now >= (frozenTime + freezePeriod));

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
      require(currentPhase==Phase.Registred);
      uint lock = lockedFunds + amount;

      if(sharesTokenAddress.balanceOf(msg.sender)< (lock)) revert();

      uint l = stake + lock;
      uint s = stake + amount;
      stake = s;
      lockedFunds = l;
    }

    function takeStake() internal {
      // double chek of state here, may been improved
      require(currentPhase==Phase.Registred);
      uint l = lockedFunds;
      lockedFunds = l - stake;
      stake = 0;
    }


    function buyRate(uint amount) public onlyOwner {

      require(currentPhase==Phase.Registred);

      uint g = Network.getGlobalRate(owner,this);
      // Check this with intence in test stage
      uint p = g / 100;
      // Rates cannot be increased more than for 10% at one buy.
      p = p * 10;

      if (amount > p) revert();
      uint lock = lockedFunds + amount;

      if(sharesTokenAddress.balanceOf(msg.sender)< (lock)) revert();

      lockedFunds = lock;
      DaoCollect += amount;
      if(!plusRate(amount)) revert();

    }
*/


//------TOKEN ITERACTION-------------------------------------------------------

    function transfer(address _to, uint _value) internal returns (bool success){

      require(currentPhase==Phase.Registred);
      uint lockFee = _value * daoFee / 1000;
      uint lock = lockedFunds + lockFee;
      uint value=_value - lockFee;
      require(token(sharesTokenAddress).balanceOf(msg.sender) < lock + value);
      lockedFunds=lock;
      DaoCollect += lockFee;
      token(sharesTokenAddress).transfer(_to,value);
      return true;
    }



    function pullMoney(address profile) public returns(bool success){
      //require(currentPhase==Phase.Registred);
      uint val =token(sharesTokenAddress).allowance(profile,this);
      require(token(sharesTokenAddress).transferFrom(profile,this,val));
      return true;
    }

//------------------------------------------------------------------------------
/*

function give(address _to, uint value) internal {


  require(currentPhase==Phase.Registred);

    //  uint lockFee = _value * daoFee / 1000;
    //  uint lock = lockedFunds + lockFee;
      uint lock = lockedFunds;
    //  uint value=_value - lockFee;

      if(sharesTokenAddress.balanceOf(msg.sender)< (lock + value)) revert();

    //  lockedFunds=lock;
    //  DaoCollect += lockFee;
      sharesTokenAddress.approve(_to,value);
}

    function PayDay() public onlyOwner {

        require(currentPhase==Phase.Registred);

        takeStake();

        //uint balance = sharesTokenAddress.balanceOf(msg.sender);

        // !CONCEPTUAL
        // should we take a fee from turn?
        //  uint turn = balance * daoFee / 1000;
      //  DaoCollect = lockedFunds;
        //DaoCollect = DaoCollect + turn;
        lockedFunds= 0;

        // Comment it if you gonna run tests.
        if(now < (frozenTime + freezePeriod)) revert();



        //dao got's 0.5% in such terms.
          sharesTokenAddress.transfer(DAO,DaoCollect);
          if (!CheckOut()) revert();

          DaoCollect = 0;

      }

    function withdraw(address to, uint amount) public onlyOwner {

      require(currentPhase==Phase.Idle);
      sharesTokenAddress.transfer(to,amount);
    }



    function suspect() public onlyDao {
      require(currentPhase==Phase.Registred);
      frozenTime = 0;
      CheckOut();
      frozenTime = uint64(now);
      currentPhase = Phase.Suspected;
      LogPhaseSwitch(currentPhase);
      freezePeriod = 120 days;

    }

    function punish() public onlyDao {
      require(currentPhase==Phase.Suspected);
      if (now < (frozenTime + freezePeriod)) revert();
      lockedFunds=sharesTokenAddress.balanceOf(this);
      uint amount = lockedFunds + stake;
      sharesTokenAddress.transfer(DAO,amount);
      currentPhase = Phase.Punished;
      LogPhaseSwitch(currentPhase);

    }

    function rehub() public onlyDao {
      require(currentPhase==Phase.Suspected);
      lockedFunds = 0;
      currentPhase = Phase.Idle;
      LogPhaseSwitch(currentPhase);
    }

*/
  }
