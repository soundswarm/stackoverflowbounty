var M8Coin = artifacts.require("M8Coin");
var M8BountyFactory = artifacts.require("M8BountyFactory");
var M8Bounty = artifacts.require("M8Bounty");

let m8Address;
let m8Factory;
let bounty;

contract("M8", async accounts => {
  beforeEach("it should deploy the factory", async () => {
    m8Factory = await M8BountyFactory.deployed();
    m8Address = await m8Factory.m8();
    m8 = await M8Coin.at(m8Address);
  });

  it("is should delpoy factory", async () => {
    assert.ok(m8Factory.address);
  });

  it("is should delpoy coin in factory constructor", async () => {
    assert.ok(m8Address);
  });

  it("factory should have a balance after it mints m8 token", async () => {
    await m8Factory.mintM8();
    const factoryBalance = await m8.balanceOf(m8Factory.address);
    assert.equal(factoryBalance, 100);
  });

  it("factory should create a bounty", async () => {
    await m8Factory.createBounty(3162032, "stackoverflow");
    const bountyAddress = await m8Factory.deployedBounties(0);
    bounty = M8Bounty.at(bountyAddress);
    assert.ok(bountyAddress);
  });

  it("bounty get accepted answer Id", async () => {
    await bounty.getAcceptedAnswerId({
      from: accounts[0],
      value: web3.toWei("0.02", "ether")
    });
    const acceptedAnswerId = await bounty.acceptedAnswerId();
    assert.ok(acceptedAnswerId);
  });
});
