var M8Coin = artifacts.require("M8Coin");
var Factory = artifacts.require("M8BountyFactory");

let m8Coings;
let m8Factory;
// function assertEvent(contract, filter) {
//   return new Promise((resolve, reject) => {
//     var event = contract[filter.event]();
//     event.watch();
//     event.get((error, logs) => {
//       console.log("LOGS", logs);
//       // var log = _.filter(logs, filter);
//       // if (log) {
//       //     resolve(log);
//       // } else {
//       //     throw Error("Failed to find filtered event for " + filter.event);
//       // }
//     });
//     event.stopWatching();
//   });
// }

contract("M8", async accounts => {
  beforeEach("it should deploy the coin and factory", async () => {
    console.log('M8COINmmm', m8Coin)

    m8Coin = await M8Coin.deployed()
    console.log('M8COINmmm', m8Coin)
    // m8Factory = await Factory.deployed()
    // console.log('M8FACTORY', m8Factory)

  });

  // it("is should delpoy coin and factory", async () => {
  //   // assert.ok(m8Coin.address)
  //   // assert.ok(m8Factory.address);
  //   // const factoryBalance= await  m8Coin.balanceOf(m8Factory.address)
  //   // console.log('FACTORYBALANCE', factoryBalance)
  // });
});
