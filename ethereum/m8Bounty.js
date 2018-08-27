import web3 from './web3';
const M8BountyJson = require('../build/contracts/M8Bounty.json').abi;

export default address => {
  return new web3.eth.Contract(M8BountyJson, address);
};
