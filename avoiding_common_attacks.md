There there is only one line of code to transfer the M8 token. The transfer function is called only after completing related logic thus minimizing of risk of hacking contract state through reentrancy. A Zeppelin ERC20 mintable token was used because they have been extensively tested.  The bounty factory is the owner of the token and hence the only account that can mint new tokens.

There is no incrementing/decrementing of numbers which avoids overflow/underflow attacks. 
