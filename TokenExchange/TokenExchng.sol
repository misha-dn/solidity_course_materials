// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "./TokenA.sol";
import "./TokenB.sol";

contract TokenExchange{
    //for simplicity deploy TokenA and TokenB from TokenExchange contract
    //initially all tokens minted by TokenA() and TokenB() belong to TokenExchange
    TokenA internal proxyTA = new TokenA();
    TokenB internal proxyTB = new TokenB();
    mapping(string => uint) public TokenBalance;

    constructor (){
        //record starting balance of tokens
        TokenBalance["TA"] = proxyTA.balanceOf(address(this));
        TokenBalance["TB"] = proxyTB.balanceOf(address(this));        
    }

    //sells tokenA or tokenB for ethers 1:1
    function buyTokenForEther(string memory TokenCode) external payable returns(uint){
        //msg.value = amount of ethers sent by a buyer
        //check which token is wanted  
        bool _tokenA = keccak256(abi.encodePacked(TokenCode))==keccak256(abi.encodePacked("TA"));
        bool _tokenB = keccak256(abi.encodePacked(TokenCode))==keccak256(abi.encodePacked("TB"));
        uint tokens_transfered;
        if( _tokenA){
            //check if the TokenExchange has enough tokens TA
            require(proxyTA.balanceOf(address(this)) >= msg.value, "Not enough TAs to sell for ethers, reverting");
            //send msg.value of TAs to the buyer
            require(proxyTA.transfer(msg.sender, msg.value)==true, "Transfer of TAs failed, reverting");            
            //reflect the change in token balance of the TokenExchange
            TokenBalance["TA"] -= msg.value;
            //check that tokens reached the buyer
            tokens_transfered = proxyTA.balanceOf(msg.sender);            
        }
        if( _tokenB){
            //check if the TokenExchange has enough tokens TA
            require(proxyTB.balanceOf(address(this)) >= msg.value, "Not enough TBs to sell for ethers, reverting");
            //send msg.value of TAs to the buyer
            require(proxyTB.transfer(msg.sender, msg.value)==true, "Transfer of TBs failed, reverting"); 
            //reflect the change in token balance of the TokenExchange
            TokenBalance["TB"] -= msg.value;
            //check that tokens reached the buyer
            tokens_transfered = proxyTB.balanceOf(msg.sender);                                     
        }
        if(_tokenA == false && _tokenB == false){
            revert("wrong token code, reverting");
        }

        return tokens_transfered;
    }

    //swaps B tokens for A 1:1
    function buyA(uint _amount) public returns(bool){
        //transfer _amount of TBs from msg.sender to TokenExchange
        //allowance is checked inside transferFrom
        require(proxyTB.transferFrom(msg.sender, address(this), _amount)==true, "cannot transfer TBs to the exchange");
        TokenBalance["TB"] += _amount;
        //tranfer _amount of TAs to msg.sender (the buyer)
        require(proxyTA.transfer(msg.sender, _amount)==true, "cannot transfer TAs to the buyer");
        TokenBalance["TA"] -= _amount;
        
        return true;
    }

    //swaps B tokens for A 1:1
    function buyB(uint _amount) public returns(bool){
        //transfer _amount of TAs from msg.sender to TokenExchange
        //allowance is checked inside transferFrom
        require(proxyTA.transferFrom(msg.sender, address(this), _amount)==true, "cannot transfer TAs to the exchange");
        TokenBalance["TA"] += _amount;
        //tranfer _amount of TBs to msg.sender (the buyer)
        require(proxyTB.transfer(msg.sender, _amount)==true, "cannot transfer TBs to the buyer");
        TokenBalance["TB"] -= _amount;
        
        return true;
    }    

    // function showBalance(string memory TokenCode) public view returns(uint){

    // }
    
}

contract testTokenBuyer{

    TokenExchange  _exchange;

    //give  TokenExchange  address as a parameter to the consructor
    constructor(address _adr){
         _exchange = TokenExchange(_adr);
    }

    //buy token A for ethers from the exchange
    function buyForEthers(uint _vol) public returns(bool) {
        address payable _to = payable(address(_exchange));
        _to.buyTokenForEther(_vol);

    }

}