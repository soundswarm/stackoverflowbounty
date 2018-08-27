import web3 from './web3';
const M8BountyFactoryJson = require('../build/contracts/M8BountyFactory.json').abi;

const instance = new web3.eth.Contract(M8BountyFactoryJson, '0x175a12b6e297c5f3904fec8b975759a418eebd5e');
export default instance;
