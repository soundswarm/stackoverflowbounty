this app allows you to post an ERC20 token bounty on a stackoverflow question.

To claim this bounty you must have an approved answer for this stackoverflow question and you must have your ethereum address posted in the location section of your stackexchange profile. The bounty will be sent to the address in your profile location. You must be signed into metamask to claim the bounty. You will have to spend your hard-earned Rinkeby eth on 3 transactions which use Oraclize. Then you will receive the bounty.

it is built with nextjs, react, oraclize, and solidity

to run in dev environment
```npm install```
```npm run dev```

to enable oraclize with tests:
ethereum-bridge -H localhost:9545 -a 1
