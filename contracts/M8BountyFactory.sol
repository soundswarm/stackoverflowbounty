pragma solidity ^0.4.18;
import 'oraclize-api/usingOraclize.sol';
import './M8Coin.sol';
import './M8Bounty.sol';


contract M8BountyFactory is usingOraclize{
    // factory craetes the m8 token and instantiates bounty contracts
    M8Coin public m8;
    function  M8BountyFactory () public payable{
        m8 = new M8Coin();
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
