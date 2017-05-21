# HUB contracts

# Hub wallet



## Abstract

Before hub started to payout tokens to miners and recive payments from buyers – he must create a hub wallet – simple contract with defined amount of frozen funds. If hub will be cheating – DAO could initiate process of blacklisting this hub and expropriate frozen funds from it.

Frozen funds it also will be frozen at DAO account for defined time – it&#39;s special protection against malicious descisions of DAO – tokens could lower it price for time from expropriation to undfreeze, therefore there is no motivation to &#39;raskulachivat&#39;(expropriate) every hub.

## Logic

Hub wallet contract have a few Phases of it's work - ```Created,Registred,Idle,Suspected,Punished ```

When the contract is created, the constructor function designates the addresses of the JSC, the factory, the whitelist, the wallet owner and a few other variables, like the length of the payout period (which is currently set at 30 days) The payout period is a period of time during which the hub can conduct payouts to miners, but cannot take the entire balance for itself.  
In the Created state the contract can be registered in the whitelist, freezing a set amount on its balance (1 SONM token). This is designed to circumvent a situation like this – the hub first deposits 0.00000001 SNM, registers the contract, and then deposits the main sum of 100 SNM – the first amount is fixed. Furthermore, the time of registration is recorded when the contract is registered in the whitelist.
After the contract has been registered in the whitelist, it becomes Registered, in which state it has access to the transfer , payday, suspect  functions. Let’s take a closer look at them in order.

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
This function enables the contract to conduct payouts to the hub miners. It works as follows: first a lockFee- is designated, a percentage of the payout which will be locked for the payout period. The default value of it is 30%. Then a limit is set (the total amount of frozen funds + the frozen amount from the registration + the percentage for this particular transaction) and the balance is checked – if the balance is below the limit, this particular transaction is not conducted, if everything is in order – the frozen percentage is added to the total amount of frozen funds and the contract invokes the Approve function (details below) towards the miner. The explanation of why the process is done this way is given in the PayDay portion of the description.

#### Approve function
This function does not move the tokens to the miner’s wallet, but permits the miner to conduct this transaction on his one. This prevents the hub from registering a wallet in the system while conducting the payouts through a separate wallet because the miner is waiting for approval from this particular wallet. Approve is a standard function. (standard ERC20).

#### PayDay function
This function is close payment period and set state of the contract as ```Idle```.

This function checks the registration time against the current date and thus can be invoked only at the end of the payout period. If this condition is met, it transfers 0.5% of the frozen funds to the JSC wallet, after which it unlocks all the frozen funds and set the contract’s state to idle. In this idle state the contract can move all the funds back to the owner’s wallet or register the contract again in the whitelist. During the idle state the hub cannot conduct payouts or be dismantled.
Thus, if the owner can move the funds from the hub to his personal wallet he can do so in two ways – do it in accordance with the rules, wait until the end of the payout period, pay the JSC 0.5% of the frozen funds and move the rest to his wallet; or he can cheat and move all the funds using the transfer function under the guise of paying miners, but in this case 30% of all funds will stay frozen +1 SNM. Such a system motivates the hub to act in compliance with the rules.
The contract also has the Suspected and Punished conditions. In the Registred state – the state when the contract can be registered in the whitelist – the JSC and only JSC can invoke the suspect function, thus setting the contract’s stats to suspected – suspected of being malicious. This function blocks all funds on the contract’s wallet for 120 days.
In the suspected state the following functions can be invoked by the JSC exclusively:


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
This can only be invoked by the DAO committee after 120 days have passed since the contract’s state has been set to suspected, then all frozen funds of the contracts get sent to the DAO wallet, the contract state is definitively set to punished , and the owner of the contract is blocked from conduction further operations using this wallet.


#### rehub function
This rehabilitates the hub, removes all fund freezes and set the contract state to  ```idle```. 
