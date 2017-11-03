var Factory = artifacts.require('./Factory.sol');
var Network = artifacts.require('./Network.sol');
var SDT = artifacts.require('./SDT.sol');
var Profile = artifacts.require('./Profile.sol');

contract('Factory', async function (accounts) {
  var network;
  var factory;
  var token;

  var hub = accounts[1];
  var client = accounts[2];

  before(async function () {
    factory = await Factory.deployed();
    network = await Network.deployed();
    token = await SDT.deployed();

    await factory.changeAdresses(network.address, token.address);

    await token.transfer(client, 1000000);
    await token.transfer(hub, 1000000);
    var lockId;
  });

  it('test null', async function () {
    assert.equal(0, 0)
  });

  it('test createHub', async function () {
    await factory.createProfile(true, {from: hub});
    var profile = await factory.getProfile(hub);
    var type = await factory.getType(profile);
    assert.equal(type, 0);
  });

  it('test createClient', async function () {
    await factory.createProfile(false, {from: client});
    var profile = await factory.getProfile(client);
    var type = await factory.getType(profile);
    assert.equal(type, 1);
  });

  // it('test openDeal', async function () {
  //   var profile_address = await factory.getProfile(client);
  //   await token.transfer(profile_address, 100000, {from: client});
  //   var profile = Profile.at(profile_address);
  //   await profile.OpenDeal(10000, 200000000000);
  // });

  it('test OpenExternalDeal & CancelDeal', async function () {
    var client_profile_address = await factory.getProfile(client);
    var hub_profile_address = await factory.getProfile(hub);
    await token.transfer(client_profile_address, 100000, {from: client});
    await token.transfer(hub_profile_address, 10000, {from: hub});
    var client_profile = Profile.at(client_profile_address);
    var hub_profile = Profile.at(hub_profile_address);
    lockId = await client_profile.OpenExternalDeal(hub_profile_address, 100, 1509657943);
    await hub_profile.CancelDeal(lockId);
  });

  // it('test CancelDeal'), async function () {
  //   var client_profile_address = await factory.getProfile(client);
  //   var hub_profile_address = await factory.getProfile(hub);
  //   var client_profile = Profile.at(client_profile_address);
  //   var hub_profile = Profile.at(hub_profile_address);
  //   await hub_profile.CancelDeal(lockId);
  // }
  it('test GetDeals', async function () {
    var client_profile_address = await factory.getProfile(client);
    var client_profile = Profile.at(client_profile_address);
    await client_profile.GetDeals('0x0');
  });

});
