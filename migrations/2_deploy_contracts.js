var M8Coin = artifacts.require("M8Coin");
var M8 = artifacts.require("M8BountyFactory");

module.exports = function(deployer) {
  deployer.deploy(M8Coin).then(function(coinInstance){
    deployer.deploy(M8, coinInstance)
  })
};
