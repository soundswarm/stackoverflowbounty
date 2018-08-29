import web3 from './web3';
const M8BountyFactoryJson = require('../build/contracts/M8BountyFactory.json').abi;

const instance = new web3.eth.Contract(M8BountyFactoryJson, '0xef0a6c4f4c27d14743bfc941734e3eeb29b0bc0b');
export default instance;
