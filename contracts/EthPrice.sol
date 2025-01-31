pragma solidity ^0.4.24;

import "./oraclize/usingOraclize.sol";

contract EthPrice is usingOraclize {

    string public ethPriceUsd;

    event LogInfo(string description);
    event LogNewEthPrice(string price);
    event LogNewOraclizeQuery(string description);

    function EthPrice() {
        update(); 
    }

    function __callback(bytes32 myid, string result) {
        require(msg.sender == oraclize_cbAddress(), 'Caller is not Oraclize!');
        emit LogNewEthPrice(result);
        ethPriceUsd = result;
    }

    function update() payable public {
        if(oraclize_getPrice("URL") > address(this).balance){
            emit LogInfo("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
           emit LogInfo("Oraclize query was sent, standing by for the answer.."); 
           emit LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
           oraclize_query("URL", "json(http://ec2-52-82-25-8.cn-northwest-1.compute.amazonaws.com.cn:9000/api/datas/0x003e64f4ab80549fec7f3d4649739d531171fcdc).avg_age");
        }

    }

}