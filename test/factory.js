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

  it('test openDeal', async function () {
    var profile_address = await factory.getProfile(client);
    await token.transfer(profile_address, 100000, {from: client});
    var profile = Profile.at(profile_address);
    await profile.OpenDeal(10000, 200000000000);
  });
});