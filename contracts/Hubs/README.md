# HUB contracts

# Hub wallet



## Abstract

Before hub started to payout tokens to miners and recive payments from buyers – he must create a hub wallet – simple contract with defined amount of frozen funds. If hub will be cheating – DAO could initiate process of blacklisting this hub and expropriate frozen funds from it.

Frozen funds it also will be frozen at DAO account for defined time – it&#39;s special protection against malicious descisions of DAO – tokens could lower it price for time from expropriation to undfreeze, therefore there is no motivation to &#39;raskulachivat&#39;(expropriate) every hub.

## Logic

Hub wallet contract have a few Phases of it's work - ```Created,Registred,Idle,Suspected,Punished ```

Let see for each of them -

1. ```Created```
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

### Registration function

This function is Registrate contract in Whitelist.
Could be invoked when ```currentPhase``` is Created or Idle.

It is check current amount of token's on Hub balance and freeze amount of tokens defined in ```freezeQuote```.
It is done this way as protection from situation when Hub can be created with small amount of tokens, registred, and then main amount of token deposits to hub wallet.

It is also set ```frozenTime``` as time of registration and invoke ```Register``` function itself.
``` Register``` function of ```Whitelist``` contract will be described later on following sections.

This function is also set currentPhase as 'Registred' 


2. ```Registred```
