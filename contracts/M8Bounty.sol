pragma solidity ^0.4.18;
import 'oraclize-api/usingOraclize.sol';
import './M8Coin.sol';

contract M8Bounty is usingOraclize{
    M8Coin public m8;

    uint public questionId;
    string public site;
    uint public acceptedAnswerId;
    uint  public winnerId;
    address public winnerAddress;

    enum QueryTypes{
        acceptedAnswerQuery,
        winnerIdQuery,
        winnerAddressQuery
    }
    mapping (bytes32 => QueryTypes) public queries;


    function M8Bounty (uint _questionId, string _site, address _m8Address) public payable {
        questionId = _questionId;
        site = _site;
        m8 = M8Coin(_m8Address);
    }
    // 3 oraclize queries are required to determine if there's a person who has an accepted answer
    // and their eth address is posted in their stackexchange location profile
    function getAcceptedAnswerId () public payable returns(uint) {
        if (acceptedAnswerId > 0) {
            return acceptedAnswerId;
        }
        string memory URL = strConcat(
            "https://api.stackexchange.com/2.2/questions/",
            uIntToStr(questionId),
            "?site=",
            site
          );
        bytes32 queryId = oraclize_query(
            "URL",
            strConcat("json(",URL,").items.0.accepted_answer_id"),
            500000
            );
        queries[queryId] = QueryTypes.acceptedAnswerQuery;
    }

    function getWinnerId () public payable returns (uint) {
         if (winnerId > 0) {
            return winnerId;
        }
        string memory URL = strConcat(
            "https://api.stackexchange.com/2.2/answers/",
            uIntToStr(acceptedAnswerId),
            "?site=",
            site
          );
        bytes32 queryId = oraclize_query(
            "URL",
            strConcat("json(",URL,").items.0.owner.user_id"),
            500000
            );
        queries[queryId] = QueryTypes.winnerIdQuery;
    }

    function claimBounty () public payable {
        string memory URL = strConcat(
            "https://api.stackexchange.com/2.2/users/",
            uIntToStr(winnerId),
            "?site=",
            site
          );
        bytes32 queryId = oraclize_query(
            "URL",
            strConcat("json(",URL,").items.0.location"),
            500000
            );
        queries[queryId] = QueryTypes.winnerAddressQuery;
    }
    function __callback(bytes32 queryId, string result) {
        require(msg.sender == oraclize_cbAddress());

        if (queries[queryId] == QueryTypes.acceptedAnswerQuery) {
            uint parsedResult = parseInt(result);
            if(parsedResult > 0) {
                acceptedAnswerId = parsedResult;
            }
        }
        if (queries[queryId] == QueryTypes.winnerIdQuery) {
            parsedResult = parseInt(result);
            if(parsedResult > 0) {
                winnerId = parsedResult;
            }
        }

        if (queries[queryId] == QueryTypes.winnerAddressQuery) {
            if (bytes(result).length > 0 && bytes(result).length == 42) {
                winnerAddress = parseAddr(result);
                m8.transfer(winnerAddress,  m8.balanceOf(this));
            }

        }

    }

    function getBounty() public view returns (uint, string, uint) {
        return (questionId, site, m8.balanceOf(this));
    }

    function uIntToStr(uint i) internal pure returns (string) {
        if (i == 0) return "0";
        uint j = i;
        uint len;
        while (j != 0){
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (i != 0){
            bstr[k--] = byte(48 + i % 10);
            i /= 10;
        }
        return string(bstr);
    }
}
