pragma solidity ^0.4.18;
import 'oraclize-api/usingOraclize.sol';
import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";


contract M8Coin is MintableToken{
    string public name = "M8 COIN";
    string public symbol = "M8B";
    uint8 public decimals = 18;
}

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

contract M8BountyFactory is usingOraclize{
    // factory craetes the m8 token and instantiates bounty contracts
    M8Coin public m8;
    function  M8BountyFactory (address _m8Address) public {
        m8 = M8Coin(_m8Address);
        m8.mint(this, 100);
    }
    struct DeployedBounty {
        uint questionId;
        string site;
    }
    address[] public deployedBounties;

    mapping(bytes32 => bool) validQuestions;

    // used for Oraclize queries
    struct QueryInfo {
      string site;
      uint questionId;
    }
    mapping(bytes32 => QueryInfo) queryInfo;

    event BountyCreated(uint queryID, string site, address bountyAddress);
    event QuestionKeyEvent(bytes32);

    // function checks to see if the question exists on stackexchange and should be called before creating bounty.
   function isValidQuestion(uint _questionId, string _site) public payable{
        require(_questionId != 0 && bytes(_site).length != 0);

        string memory URL = strConcat(
            "https://api.stackexchange.com/2.2/questions/",
            uIntToStr(_questionId),
            "?site=",
            _site
          );
        bytes32 queryId = oraclize_query(
            "URL",
            strConcat("json(",URL,").items.0.creation_date"),
            500000
            );
        queryInfo[queryId].site = _site;
        queryInfo[queryId].questionId =_questionId;
    }
    function __callback(bytes32 queryID, string result) {
        require(msg.sender == oraclize_cbAddress());
        uint parsedResult = parseInt(result);
        string memory site =  queryInfo[queryID].site;
        uint questionId =  queryInfo[queryID].questionId;
        delete queryInfo[queryID];
        if (parsedResult > 0) {
            bytes32 questionKey = makeQuestionKey(questionId, site);
            validQuestions[questionKey] = true;
            QuestionKeyEvent(questionKey);
        }
    }

    function createBounty(uint _questionId, string _site) public payable{
        require(_questionId != 0 && bytes(_site).length != 0);
        // require question doesn't already exist.
        bytes32 questionKey = makeQuestionKey(_questionId, _site);
        // require(validQuestions[questionKey] == true);

        address newBounty = new M8Bounty(_questionId, _site, m8);
        m8.transfer(newBounty, 10);
        deployedBounties.push(newBounty);
        BountyCreated(_questionId, _site, newBounty);
    }

    function getDeployedBounties() public view returns (address[]) {
        return deployedBounties;
    }
    function makeQuestionKey(uint _questionId, string _site) public pure returns(bytes32){
        string memory question = strConcat(uIntToStr(_questionId), ',' , _site);
        bytes32 key = keccak256(question);
        return key;
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
