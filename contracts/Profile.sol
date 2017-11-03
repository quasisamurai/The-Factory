pragma solidity ^0.4.13;


//sonm profile abstraction


import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import "./Dealable.sol";
import "./Declaration.sol";


contract Profile is Ownable, Dealable {

    /*/
     *  Constants
    /*/


    //Fee's
    uint daoFee = 1;

    uint daoCollect;

    address public dao;

    address public Factory;

    address Network;

    bool public isHub;

    address public sharesTokenAddress;

    uint deals_count = 0;

    uint public lockedFunds = 0;

    address owner;

    //adress of seller(for client profile)/ buyer (for hub profile) =>  lockid
    mapping (address => uint[]) mydeals;


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

    event DealAppealed(address buyer, address seller, uint cost, uint lockid);

    // constructor

    function Profile(address _profileowner, address _dao, address Sonm, address _sharesTokenAddress, bool _isHub){
        owner = _profileowner;
        dao = _dao;
        Network = Sonm;
        sharesTokenAddress = _sharesTokenAddress;
        isHub = _isHub;
    }

    modifier onlyDao(){if (msg.sender != dao) revert();
        _;}
    modifier onlyHub(){require(isHub == true);
        _;}
    modifier onlyClient(){require(isHub == false);
        _;}


    function GetDeals(address _contragentAddress) constant returns (uint256[]){
        return mydeals[_contragentAddress];
    }

    // Deals-------------------------------------------------------------------

    function OpenExternalDeal(address _sellerAddress, uint cost, uint _endTime) public onlyClient returns (bool success){
        //  id of concrete deal
        uint lockId;
        profile seller = profile(_sellerAddress);
        require(token(sharesTokenAddress).approve(_sellerAddress, cost));
        seller.OpenDeal(cost, _endTime);
        mydeals[_sellerAddress].push(lockId);
        deals_count++;
        return true;
    }


    function OpenDeal(uint cost, uint _endTime) public returns (uint lockId){
        DebugAddress(this);
        //require(currentPhase==Phase.Registred);
        address buyer = msg.sender;
        lockId = deals_count;
        require(super.start(lockId, cost, buyer, _endTime));
        pullMoney(buyer, cost);
        lockedFunds += cost;
        mydeals[buyer].push(lockId);
        deals_count++;
        DealOpened(msg.sender, this, cost, lockId);
        return lockId;
    }

    function CancelDeal(uint _lockId) public returns (bool success) {
        DebugAddress(this);
        //require(currentPhase==Phase.Registred);
        require(super.cancel(_lockId, msg.sender));
        uint cost = super.getCost(_lockId);
        lockedFunds -= cost;
        //transfer(msg.sender, cost);
        DealCanceled(msg.sender, this, cost, _lockId);
        return true;
    }

    function AcceptDeal(uint _lockId) public onlyOwner onlyHub returns (bool success){
        DebugAddress(this);
        //require(currentPhase==Phase.Registred);
        require(super.accept(_lockId));
        uint cost = super.getCost(_lockId);
        address buyer = super.getBuyer(_lockId);
        DealAccepted(buyer, msg.sender, cost, _lockId);
        return true;
    }

    function CloseDeal(uint _lockId) public onlyClient returns (bool success) {
        //require(currentPhase==Phase.Registred);
        uint cost = super.getCost(_lockId);
        require(super.done(_lockId, msg.sender));
        require(PayAsYouGo(_lockId));
        DealIsDone(msg.sender, this, cost, _lockId);
        return true;
    }

    // count funds hub to recieve, in proportion to time worked
    function PayAsYouGo(uint _lockId) public onlyOwner returns (bool success){
        uint nowTime = block.timestamp;
        uint cost = super.getCost(_lockId);
        uint endTime = super.getEndTime(_lockId);
        uint startTime = super.getStartTime(_lockId);
        uint withdrawedAmount = super.getWithdrawedFunds(_lockId);
        //pps is the price per second;
        uint pps = cost / (endTime - startTime);
        uint withdrawAmount = (nowTime - startTime) * pps - withdrawedAmount;
        lockedFunds -= withdrawAmount;
        updateWithdrawedFunds(_lockId, withdrawAmount);
        return true;
    }

    function Withdrawl(address _whom, uint _amount) public onlyOwner returns (bool success){
        require(transfer(_whom, _amount));
        return true;
    }

    //------TOKEN ITERACTION-------------------------------------------------------

    function transfer(address _to, uint _value) internal returns (bool success){
        //require(currentPhase==Phase.Registred);
        //uint lockFee = _value * daoFee / 1000;
        uint lockFee = 1;
        uint lock = lockedFunds + lockFee;
        uint value = _value - lockFee;
        require(token(sharesTokenAddress).balanceOf(msg.sender) < lock + value);
        lockedFunds = lock;
        daoCollect += lockFee;
        token(sharesTokenAddress).transfer(_to, value);
        return true;
    }


    function pullMoney(address profile, uint amount) public returns (bool success){
        //require(currentPhase==Phase.Registred);
        require(token(sharesTokenAddress).transferFrom(profile, this, amount));
        return true;
    }

    function getComission() public onlyDao returns (bool success){
        require(transfer(dao, daoCollect));
        return true;
    }
}
