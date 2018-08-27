var M8 = artifacts.require("M8BountyFactory");

let m8Factory;
let bounty;
let bountyAddress;
const bountyAmount = "20000000000000000";
function assertEvent (contract, filter)  {
    return new Promise((resolve, reject) => {
        var event = contract[filter.event]();
        event.watch();
        event.get((error, logs) => {
          console.log('LOGS', logs)
            // var log = _.filter(logs, filter);
            // if (log) {
            //     resolve(log);
            // } else {
            //     throw Error("Failed to find filtered event for " + filter.event);
            // }
        });
        event.stopWatching();
    });
}


contract("M8", async accounts => {
  beforeEach("it should deploy the factory", async () => {
    m8Factory = await M8.deployed();
    // console.log('M8FACTORY', m8Factory.createBounty)
    const t = await m8Factory.createBounty(21083538, "stackoverflow", {
      from: accounts[0],
      value: web3.toWei(0.05, "ether"),
      // gas: "30000000"
    });


    // bountyAddress = await m8Factory.getDeployedBounties();
  });

  it("is should delpoy factory", async () => {
    assert.ok(m8Factory);
  });

  it("is should create new bounty with balance", async () => {
    // assertEvent('BountyCreated')

    // console.log('BOUNTY', bountyAddress)
    // const watcher = async(err, result)=>{
    //   console.log('RESULT', result)
    //
    // }
    // await awaitEvent(event, watcher);
    // console.log('BOUNTYADDRESS', bountyAddress)
    // const b = await bounty.getBounty()
    // console.log('B', b)
  });
});







// // test events fired in CB
// function awaitEvent(event, handler) {
//   return new Promise((resolve, reject) => {
//     function wrappedHandler(...args) {
//       Promise.resolve(handler(...args))
//         .then(resolve)
//         .catch(reject);
//     }
//
//     event.watch(wrappedHandler);
//   });
// }
//     let checkForNumber = new Promise((resolve, reject) => {
//       // watch for our LogResultReceived event
//       LogResultReceived.watch(async function(error, result) {
//         if (error) {
//           reject(error)
//         }
//         // template.randomNumber() returns a BigNumber object
//         const bigNumber = await template.randomNumber()
//         // convert BigNumber to ordinary number
//         const randomNumber = bigNumber.toNumber()
//         // stop watching event and resolve promise
//         LogResultReceived.stopWatching()
//         resolve(randomNumber)
//       }) // end LogResultReceived.watch()
//     }) // end new Promise
