This Dapp allows you to post an ERC20 token (M8) bounty on a stackoverflow question.  There is a factory contract that instantiates the mintable M8 token contract int its constructor function. The factory creates a new bounty contract instance when a user puts the bounty on a question.

To claim a bounty you must have an approved answer for a stackoverflow question and you must have your ethereum address posted in the location section of your stackexchange profile. The bounty will be sent to the address in your profile location. You must be signed into metamask to claim the bounty. You will have to spend your hard-earned Rinkeby eth on 3 transactions which use Oraclize. Then you will receive the bounty.


Web app user flow:
1) enter stackoverflow questionId of the question you want to hold the M8 bounty.
For example, 31079081 is the questionId
https://stackoverflow.com/questions/31079081/programmatically-navigate-using-react-router

2) See list of bounties.

3) View Bounty question and details

4) Claim bounty.


it is built with nextjs, react, oraclize, truffle and solidity


Dapp is deployed on the Rinkeby testnet.  You must be signed into metamsk on Rinkeby.
https://questionbounty.now.sh/




to run in dev environment on Rinkeby:
```npm install```
```npm run dev```


to test:
```truffle develop```
truffle should be running on port 9545

You must enable oraclize with tests:
You must install ethereum-bridge: ```npm i --save ethereum-bridge -g```
start it after truffle's ganache is running. ethereum-bridge -H localhost:9545 -a 1

be aware of a bug in truffle test: https://github.com/trufflesuite/truffle/issues/1057
