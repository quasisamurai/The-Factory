# HUB contracts

# Hub wallet



## Abstract

Before hub started to payout tokens to miners and recive payments from buyers – he must create a hub wallet – simple contract with defined amount of frozen funds. If hub will be cheating – DAO could initiate process of blacklisting this hub and expropriate frozen funds from it.

Frozen funds it also will be frozen at DAO account for defined time – it&#39;s special protection against malicious descisions of DAO – tokens could lower it price for time from expropriation to undfreeze, therefore there is no motivation to &#39;raskulachivat&#39;(expropriate) every hub.

## Logic

Hub wallet contract have a few Phases of it's work - ```Created,Registred,Idle,Suspected,Punished ```

Let see for each of them -

### ```Created```
Hub wallet us created when contract of it is created and no one other function is invoked.

When this contract created - ```constructor ``` function is setting next parameters -
``` owner,DAO, Whitelist, Factory, genesisTime , sharesTokenAddress , freezeQuote , lockPercent , daoFee , freezePeriod  ```
Majority of it should be setted by ```Hub factory``` contract.

Let's see on every of this variables closely.

``` owner, DAO , Whitelist , Factory ``` - set owner of this contract, define addresses of DAO,Whitelist and Factory.
``` Factory ``` - is setted as ```msg.sender``` therefore anyone could check, that this contract is definetly was deployed by Factory. It is obviously could be pitfall therefore this is temporary signe. I suppose that checking deployer of conract should process throught defining original deployer of contract itself from blockchain but not as variable inside of contract.

``` genesisTime ``` - just time of creation of contract. I use it in my own purpose. In future it might be used in rating system.

```sharesTokenAddress``` - define SONM token contract.

``` freezeQuote ``` - quote of SONM tokens which is strongly neccesary to have to register this conract in ```Whitelist ```

``` lockPercent ``` - will be described below
```daoFee ``` - DAO fee in promilles (1/1000)
```freezePeriod``` - payments turnover period, will be described below

#### Registration function

This function is Registrate contract in Whitelist.
Could be invoked when ```currentPhase``` is Created or Idle.

It is check current amount of token's on Hub balance and freeze amount of tokens defined in ```freezeQuote```.
It is done this way as protection from situation when Hub can be created with small amount of tokens, registred, and then main amount of token deposits to hub wallet.

It is also set ```frozenTime``` as time of registration and invoke ```Register``` function itself.
``` Register``` function of ```Whitelist``` contract will be described later on following sections.

This function is also set currentPhase as 'Registred'


### ```Registred```
Registred phase is phase when Hub contract Registred in Whitelist (Who could think likt that?!)

In this case following functions - ```transfer``` and ```PayDay```. Also DAO could initiated ```suspect``` function.

#### transfer function.
This function is do next steps:

1. Defining ```lockFee``` - fee that will be temporary lock by every transfer from this hub in payment period.
for default it is equal 30%. More about that will be described below.
2. Defining ```lock``` - lockedFunds + lockFee
3. Defining ```limit ``` - lock + frozenFunds
4. Checking if Hub is enough to payout - throught check balance and limit.
5. Add lock to lockedFunds
6. Approve allowance of miner to ```transferFrom``` from hub wallet. It is done for preventing payout procees 'v obhod' of this system. (Miner contract like ```tokenRecepient``` should invoke ```transferFrom``` from hub wallet contract and it will be hardcoded in system)

#### PayDay function
This function is close payment period and set state of the contract as ```Idle```.

This function is check that time of payment period is pass and if so - transfer 0.5% from lockedFunds to the DAO contract. After that it is clear amount of lockedFunds.

This mean that the only way to hub to get all his money including lockedFunds - is to invoke this function and pay DAO 0.5% of lockedFunds. In any other case 30% from all hub's operation's will be locked on the contract balance.

#### Suspect function
DAO could set hub as 'suspected' in malicious things. All funds are frozen to 120 days.
Hub could be reabilitate and get funds back or it could be punished (after 120 days) and all funds will go to the DAO.

### Idle

#### withdraw function
Withdraw funds to hub owner.

#### registrate function
see registrate section

### Suspected

#### gulag function
Sends all funds from Suspected hub wallet to DAO (if 120 days is past since getting Suspected status)

#### rehub function
Reabilate hub and unlock everything.
