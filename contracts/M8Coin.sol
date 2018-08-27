pragma solidity ^0.4.18;
import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";

contract M8Coin is MintableToken{
    string public name = "M8 COIN";
    string public symbol = "M8B";
    uint8 public decimals = 18;
}
