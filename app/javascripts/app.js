
//  TODO : CONVERT FUNCTIOS.
//  TODO : cleanup code
//  TODO : clean appendix
// Import the page's CSS. Webpack will know what to do with it.

import '../stylesheets/app.css'

// Import libraries we need.

import { default as Web3 } from 'web3'
import { default as contract } from 'truffle-contract'

// import each from 'async/each';

// Import our contract artifacts and turn them into usable abstractions.

import token_artifacts from '../../build/contracts/SDT.json'
import factory_artifacts from '../../build/contracts/Factory.json'

import hub_artifacts from '../../build/contracts/Profile.json'

//import miner_artifacts from '../../build/contracts/MinerProfile.json'
import network_artifacts from '../../build/contracts/Network.json'

import client_artifacts from '../../build/contracts/Profile.json'

import cr_artifacts from '../../build/contracts/creator.json'


// const async = require('async');

// const request = require('request-promise') ;
// var rp = request;
//
var Token = contract(token_artifacts)
var Factory = contract(factory_artifacts)
var Hub = contract(hub_artifacts)
//var Miner = contract(miner_artifacts)
var Network = contract(network_artifacts)
var Client = contract(client_artifacts)
var Creator = contract(cr_artifacts)

// The following code is simple to show off interacting with your contracts.
// As your needs grow you will likely need to change its form and structure.
// For application bootstrapping, check out window.addEventListener below.
var accounts
var account
var event
var address
var hubaddress
var mineraddress
var balance
// var tokend;

window.App = {
  start: function () {
    var self = this
    var msg
    var tx
    var pos

    // Bootstrap the SONM contracts abstraction for Use.
    Token.setProvider(web3.currentProvider)
    Factory.setProvider(web3.currentProvider)
    Hub.setProvider(web3.currentProvider)
    //Miner.setProvider(web3.currentProvider)
    Network.setProvider(web3.currentProvider)
    Client.setProvider(web3.currentProvider)
    Creator.setProvider(web3.currentProvider)

    // Get the initial account balance so it can be displayed.
    web3.eth.getAccounts(function (err, accs) {
      if (err != null) {
        alert('There was an error fetching your accounts.')
        return
      }
      if (accs.length === 0) {
        alert('Couldn\'t get any accounts! Make sure your Ethereum client is configured correctly.')
        return
      }
      accounts = accs
      account = accounts[0]
      console.log('tx:')
      console.log(tx)
      msg = 'Transaction complete'
      self.setStatusPos(pos, msg)
    })
  },

  setStatus: function (message) {
    var status = document.getElementById('status')
    status.innerHTML = message
  },

  setStatusPos: function (pos, msg) {
    $(pos).html(msg)
  },

  refreshAddress: function () {
    var self=this
    var tok
    Token.deployed().then(function (instance) {
      tok = instance
      //  console.log(tok);
      $('#tokdAddress').html(tok.address)
      //  console.log(tok.address);

      //  self.hubBalance();
        self.networkAddr();
      return tok.symbol.call()
    }).then(function (sym) {
      $('#t_sym1').html(sym)
      //  console.log(sym);
    })
  },

  networkAddr: function () {
    var self = this
    var pos = '#network'
    var instance
    var msg
    var whl
    Network.deployed().then(function (instance) {
      whl = instance
      $('#network').html(whl.address)
      console.log(whl.address)
    })
  },

  changeAdresses: function () {
    var self = this
    var pos = '#network'
    var instance
    var msg
    var fac
    var dao = account
    var debugMsg
    var debugAdr
    var r1
    var to = $('#address1').val()
    Factory.deployed().then(function (instance) {
      fac = instance
      // Listening evetns for debugging
      debugMsg = fac.LogDebug({}, {fromBlock: 0, toBlock: 'latest'})
      debugMsg.watch(function (error, result) {
          r1 = JSON.stringify(result)
          //  console.log(r1);
          //  console.log(error);
        }
      )
      debugAdr = fac.DebugAddress({}, {fromBlock: 0, toBlock: 'latest'})
      debugAdr.watch(function (error, result) {
          r1 = JSON.stringify(result)
          //  console.log(r1);
          //  console.log(error);
        }
      )
      return fac.changeAdresses(dao, to, {from: account})
    }).then(function (tx) {
      console.log('tx:')
      console.log(tx)

      msg = 'Transaction complete'
      self.setStatusPos(pos, msg)
      self.refreshAddress()
    }).catch(function (e) {
      console.log(e)

      msg = 'Ошибка при отправке, смотри консоль'
      self.setStatusPos(pos, msg)
      console.log(r1)
    })

  },

  registerHub: function () {
    var self = this;
    var pos = '#hubreg_result';
    // var instance;
    var msg;
    var hb;
    var hbdr = $('#hub_address').val()
    Hub.at(hbdr).then(function (instance) {
      hb = instance;
      console.log('hmm');
      return hb.Registration({from: account, gas: 3000000});
    }).then(function (tx) {

      console.log('tx:');
      console.log(tx);
      msg = 'Transaction complete';
      self.setStatusPos(pos, msg);
      //   self.refreshAddress();
    }).catch(function (e) {
      console.log(e);
      msg = 'Ошибка при отправке, смотри консоль';
      self.setStatusPos(pos, msg);
    })
  },

  registerClient: function () {
    var self = this;
    var pos = '#clientreg_result';
    var instance;
    var msg;
    var cli;
    ClientProfile.at(cliaraddress).then(function (instance) {
      cli = instance;
      return cli.Registration({from: account})
    }).then(function (tx) {

      console.log('tx:');
      console.log(tx);
      msg = 'Transaction complete';
      self.setStatusPos(pos, msg);
      //   self.refreshAddress();
    }).catch(function (e) {
      console.log(e);
      msg = 'Ошибка при отправке, смотри консоль';
      self.setStatusPos(pos, msg);
    })
  },

  createNw: function () {
    var self=this;
    var instance;
    var nwt;

    Creator.deployed().then(function (instance) {
      nwt = instance;
      return nwt.rep({from: account})
    }).then(function (tx) {

      console.log('tx:');
      console.log(tx);

    }).catch(function (e) {
      console.log(e);


    })

  },

  createHub: function () {
      var self = this;
      var pos = '#hubCreate_result';
      var instance;
      var msg;
    //  var priv = $('#privatehub').is(':checked');
      var fac;
      Factory.deployed().then(function (instance) {
        fac = instance;
        return fac.createHub({from: account})
      }).then(function (tx) {
        hubaddress = tx;
        console.log('tx:');
        console.log(tx);
        msg = 'Transaction complete';
        self.setStatusPos(pos, msg);
        self.refreshAddress();
      }).catch(function (e) {
        console.log(e);

        msg = 'Ошибка при отправке, смотри консоль';
        self.setStatusPos(pos, msg);
      })

    },

    createClient: function () {

     var self = this;
      var pos = '#clientCreate_result'
      var instance
      var msg
      var fac

     Factory.deployed().then(function (instance) {
       fac = instance;
     return fac.createClient({from: account})
    }).then(function (tx) {
      clientaddress = tx;
      console.log('tx:');
      console.log(tx);
      msg = 'Transaction complete';
      self.setStatusPos(pos, msg);
      self.refreshAddress();
    }).catch(function (e) {
      console.log(e);
      msg = 'Ошибка при отправке, смотри консоль';
      self.setStatusPos(pos, msg);
    })

  },


  /*
  createMiner: function () {
    var self = this;
    var pos = '#minCreate_result';
    var instance;
    var msg;
    Factory.deployed().then(function (instance) {
      fac = instance;
      return fac.createMiner({from: account})
    }).then(function (tx) {
      mineraddress = tx;
      console.log('tx:');
      console.log(tx);
      msg = 'Transaction complete';
      self.setStatusPos(pos, msg);
      self.refreshAddress();
    }).catch(function (e) {
      console.log(e);
      msg = 'Ошибка при отправке, смотри консоль';
      self.setStatusPos(pos, msg);
    })

  },

  registerMiner: function () {
    var self = this;
    var pos = '#minreg_result';
    var instance;
    var msg;
    var mn;
    Miner.at(mineraddress).then(function (instance) {
      mn = instance;
      return mn.Registration({from: account})
    }).then(function (tx) {
      console.log('tx:');
      console.log(tx);
      msg = 'Transaction complete';
      self.setStatusPos(pos, msg);
      self.refreshAddress();
    }).catch(function (e) {
      console.log(e);
      msg = 'Ошибка при отправке, смотри консоль';
      self.setStatusPos(pos, msg);
    })

  },
  */

  checkClient: function () {
    var self = this;
    var pos = '#checkStat';
    var instance;
    var msg;
    var cli;
    ClientProfile.at(cliaraddress).then(function (instance) {
      cli = instance;
      return cli.checkBug({from: account})
    }).then(function (tx) {

      console.log('tx:');
      console.log(tx);
      msg = 'Transaction complete';
      self.setStatusPos(pos, msg);
      //   self.refreshAddress();
    }).catch(function (e) {
      console.log(e);
      msg = 'Ошибка при отправке, смотри консоль';
      self.setStatusPos(pos, msg);
    })
  },

  sendPay: function () {
    var self = this
    var pos = '#transfer_result'
    var instance
    var msg
    var hb
    var hbdr = $('#hub_address').val()
    console.log(hbdr)
    var val = $('#transfer_am').val()
    var to = $('#transfer_to').val()
    console.log(to)
    console.log(val)
    Hub.at(hbdr).then(function (instance) {
      hb = instance
      console.log(hb)
      //  return hb.transfer({from: account, gas: 3000000})
      return hb.transfer(to, val, {from: account, gas: 3000000})
    }).then(function (tx) {
      console.log('tx:')
      console.log(tx)
      msg = 'Transaction complete'
      self.setStatusPos(pos, msg)
      self.refreshAddress()
    }).catch(function (e) {
      console.log(e)
      msg = 'Ошибка при отправке, смотри консоль'
      self.setStatusPos(pos, msg)
    })

  },

  payDay: function () {
    var self = this
    var pos = '#hubreg_result'
    var instance
    var msg
    var hb

    var hbdr = $('#hub_address').val()

    Hub.at(hbdr).then(function (instance) {
      hb = instance
      return hb.PayDay({from: account, gas: 4000000})
    }).then(function (tx) {

      console.log('tx:')
      console.log(tx)
      msg = 'Transaction complete'
      self.setStatusPos(pos, msg)
      self.refreshAddress()
    }).catch(function (e) {
      console.log(e)

      msg = 'Ошибка при отправке, смотри консоль'
      self.setStatusPos(pos, msg)
    })

  },

  DaoFee: function () {
    var self = this
    var pos = '#hubreg_result'
    var instance
    var msg
    var hb
    var hbdr = $('#hub_address').val()
    Hub.at(hbdr).then(function (instance) {
      hb = instance
      return hb.DaoTransfer({from: account, gas: 4000000})
    }).then(function (tx) {
      console.log('tx:')
      console.log(tx)
      msg = 'Transaction complete'
      self.setStatusPos(pos, msg)
      self.refreshAddress()
    }).catch(function (e) {
      console.log(e)
      msg = 'Ошибка при отправке, смотри консоль'
      self.setStatusPos(pos, msg)
    })

  },

  h_WithDraw: function () {
    var self = this
    var pos = '#hubWith_result'
    var instance
    var msg
    var hb
    var hbdr = $('#hub_address').val()
    Hub.at(hbdr).then(function (instance) {
      hb = instance
      return hb.withdraw({from: account, gas: 4000000})
    }).then(function (tx) {
      console.log('tx:')
      console.log(tx)
      msg = 'Transaction complete'
      self.setStatusPos(pos, msg)
      self.refreshAddress()
    }).catch(function (e) {
      console.log(e)
      msg = 'Ошибка при отправке, смотри консоль'
      self.setStatusPos(pos, msg)
    })

  },

/*
  pullMoney: function () {
    var self = this
    var pos = '#pullmoney_result'
    var instance
    var msg
    var mn
    var from = $('#pull_from').val()
    Miner.at(mineraddress).then(function (instance) {
      mn = instance
      return mn.pullMoney(from, {from: account})
    }).then(function (tx) {
      console.log('tx:')
      console.log(tx)
      msg = 'Transaction complete'
      self.setStatusPos(pos, msg)
      self.refreshAddress()
    }).catch(function (e) {
      console.log(e)
      msg = 'Ошибка при отправке, смотри консоль'
      self.setStatusPos(pos, msg)
    })
  },

  unregMiner: function () {
    var self = this
    var pos = '#unreg_result'
    var instance
    var msg
    var mn
    Miner.at(mineraddress).then(function (instance) {
      mn = instance
      return mn.PayDay({from: account})
    }).then(function (tx) {
      console.log('tx:')
      console.log(tx)
      msg = 'Transaction complete'
      self.setStatusPos(pos, msg)
      self.refreshAddress()
    }).catch(function (e) {
      console.log(e)
      msg = 'Ошибка при отправке, смотри консоль'
      self.setStatusPos(pos, msg)
    })
  },

  withdrawMiner: function () {
    var self = this
    var pos = '#wMiner_result'
    var instance
    var msg
    var mn
    Miner.at(mineraddress).then(function (instance) {
      mn = instance
      return mn.withdraw({from: account})
    }).then(function (tx) {
      console.log('tx:')
      console.log(tx)
      msg = 'Transaction complete'
      self.setStatusPos(pos, msg)
      self.refreshAddress()
    }).catch(function (e) {
      console.log(e)
      msg = 'Ошибка при отправке, смотри консоль'
      self.setStatusPos(pos, msg)
    })
  },
*/
  suspectHub: function () {
    var self = this
    var pos = '#suspect_hub'
    var instance
    var msg
    var hb
    var addr = $('#hub_address').val()
    Hub.at(addr).then(function (instance) {
      hb = instance
      return hb.suspect({from: account})
    }).then(function (tx) {
      console.log('tx:')
      console.log(tx)
      msg = 'Transaction complete'
      self.setStatusPos(pos, msg)
      self.refreshAddress()
    }).catch(function (e) {
      console.log(e)
      msg = 'Ошибка при отправке, смотри консоль'
      self.setStatusPos(pos, msg)
    })

  },

/*
  suspectMiner: function () {
    var self = this
    var pos = '#suspect_miner'
    var instance
    var msg
    var mn
    var addr = $('#min_address').val()
    Miner.at(addr).then(function (instance) {
      mn = instance
      return mn.suspect({from: account})
    }).then(function (tx) {
      console.log('tx:')
      console.log(tx)
      msg = 'Transaction complete'
      self.setStatusPos(pos, msg)
      self.refreshAddress()
    }).catch(function (e) {
      console.log(e)
      msg = 'Ошибка при отправке, смотри консоль'
      self.setStatusPos(pos, msg)
    })

  },
  */

  gulagHub: function () {
    var self = this
    var pos = '#gulag_hub'
    var instance
    var msg
    var hb
    var addr = $('#hub_address').val()
    Hub.at(addr).then(function (instance) {
      hb = instance
      return hb.gulag({from: account})
    }).then(function (tx) {
      console.log('tx:')
      console.log(tx)
      msg = 'Transaction complete'
      self.setStatusPos(pos, msg)
      self.refreshAddress()
    }).catch(function (e) {
      console.log(e)
      msg = 'Ошибка при отправке, смотри консоль'
      self.setStatusPos(pos, msg)
    })

  },

  rehubHub: function () {
    var self = this
    var pos = '#rehub_hub'
    var instance
    var msg
    var hb
    var addr = $('#hub_address').val()
    Hub.at(addr).then(function (instance) {
      hb = instance
      return hb.rehub({from: account})
    }).then(function (tx) {
      console.log('tx:')
      console.log(tx)
      msg = 'Transaction complete'
      self.setStatusPos(pos, msg)
      self.refreshAddress()
    }).catch(function (e) {
      console.log(e)
      msg = 'Ошибка при отправке, смотри консоль'
      self.setStatusPos(pos, msg)
    })

  },

/*
  gulagMiner: function () {
    var self = this
    var pos = '#gulag_miner'
    var instance
    var msg
    var mn
    var addr = $('#min_address').val()
    Miner.at(addr).then(function (instance) {
      mn = instance
      return mn.gulag({from: account})
    }).then(function (tx) {
      console.log('tx:')
      console.log(tx)
      msg = 'Transaction complete'
      self.setStatusPos(pos, msg)
      self.refreshAddress()
    }).catch(function (e) {
      console.log(e)
      msg = 'Ошибка при отправке, смотри консоль'
      self.setStatusPos(pos, msg)
    })

  },

  rehubMiner: function () {
    var self = this
    var pos = '#rehub_miner'
    var instance
    var msg
    var mn
    var addr = $('#min_address').val()
    Miner.at(addr).then(function (instance) {
      mn = instance
      return mn.rehub({from: account})
    }).then(function (tx) {
      console.log('tx:')
      console.log(tx)
      msg = 'Transaction complete'
      self.setStatusPos(pos, msg)
      self.refreshAddress()
    }).catch(function (e) {
      console.log(e)
      msg = 'Ошибка при отправке, смотри консоль'
      self.setStatusPos(pos, msg)
    })

  },
*/
  getProfile: function () {
    var self = this
    var pos
    var msg
    var fac
    var addr = $('#address_to_check').val()
    Factory.deployed().then(function (instance) {
      fac = instance
      return fac.getProfile(addr, {from: account})
    }).then(function (tx) {
      address = tx
      console.log('Here is address of ')
      console.log(tx)
      msg = 'Transaction complete'
      self.setStatusPos(pos, msg)
      self.refreshAddress()
    }).catch(function (e) {
      console.log(e)
      msg = 'Ошибка при отправке, смотри консоль'
      self.setStatusPos(pos, msg)
    })

  },

  getType: function () {
    var self = this
    var pos
    var msg
    var fac
    var addr = $('#address_to_check').val()
    Factory.deployed().then(function (instance) {
      fac = instance
      return fac.getType(addr, {from: account})
    }).then(function (tx) {
      address = tx
      console.log('Type of this address is ')
      console.log(tx)
      msg = 'Transaction complete'
      self.setStatusPos(pos, msg)
      self.refreshAddress()
    }).catch(function (e) {
      console.log(e)
      msg = 'Ошибка при отправке, смотри консоль'
      self.setStatusPos(pos, msg)
    })

  },

  isPrivate: function () {
    var self = this
    var pos = 'IsPrivate'
    var msg
    var fac
    var addr = $('#address_to_check').val()
    Factory.deployed().then(function (instance) {
      fac = instance
      return fac.isPrivate(addr, {from: account})
    }).then(function (tx) {
      address = tx
      console.log('Is it private profile? ')
      console.log(tx)
      msg = 'Transaction complete'
      self.setStatusPos(pos, msg)
      self.refreshAddress()
    }).catch(function (e) {
      console.log(e)
      msg = 'Ошибка при отправке, смотри консоль'
      self.setStatusPos(pos, msg)
    })


  },

  /*
  sendToken: function () {
    var self=this;
    var pos="#transfer_result";
    var instance;
    var msg;
    var tok;
    var val = $("#transfer_am").val();
    var to = $("#transfer_to").val();

    val=web3.toWei(val);
  //  to=web3.toWei(val);


    Token.at(address).then(function(instance){
      tok=instance;
      msg="Wait..";

       return tok.transfer(to, val, {from: account})
     }).then(function (tx) {
          console.log("tx:");
          console.log(tx);
          msg="Transaction complete";
          self.setStatusPos(pos,msg);
          self.refreshAddress();
    }).catch(function(e) {
        console.log(e);

       msg="Ошибка при отправке, смотри консоль";
       self.setStatusPos(pos,msg);
      });
  },
  */



  deployContract: function () {
    var self = this
    var name = $('#t_name').val()
    var sym = $('#t_sym').val()
    var val = $('#t_val').val()
    val = Number(val)
    var dec = 18

    Token.new(val, name, dec, sym, {from: accounts[0], gas: 3000000}).then(function (instance) {

      if (!instance.address) {
        console.log('Contract transaction send: TransactionHash: ' + instance.transactionHash + ' waiting to be mined...')

      } else {
        console.log('Contract mined! Address: ' + instance.address)
        console.log(contract)
      }

//Этот адрес можно потом передавать на бекенд или куда-нибудь еще
      console.log(instance.address)

    })
//Функция которая должна быть вызвана после размещения нового контракта.
//event.stopWatching();
//App.start();
// App.sellerInvoice();
//App.sellerCurrent();

  },

  startManager: function () {
    var self = this

    var instance
    var msg
    var tok

    var val = $('#address').val()
    address = val

    self.start()
  },

// End of window.App
}

window.addEventListener('load', function () {
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    console.warn('Using web3 detected from external source. If you find that your accounts don\'t appear or you have 0 Coin, ensure you\'ve configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask')
    // Use Mist/MetaMask's provider
    window.web3 = new Web3(web3.currentProvider)
  } else {
    console.warn('No web3 detected. Falling back to http://localhost:8545. You should remove this fallback when you deploy live, as it\'s inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask')
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'))
  }

  App.start()
})
