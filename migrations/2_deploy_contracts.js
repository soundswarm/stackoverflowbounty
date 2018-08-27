var M8 = artifacts.require("M8BountyFactory");
console.log('M8', M8)

module.exports = function(deployer) {
  deployer.deploy(M8)
};
