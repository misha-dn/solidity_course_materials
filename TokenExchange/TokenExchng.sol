// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "./TokenA.sol";
import "./TokenB.sol";

// 1) deploy TockenExchange, it creates TokenA and TokenB
// 2) deploy testTokenBuyer(address(TockenExchange), address(TockenA))
// 2.1) buyForEthers (buys TokenA for ethers from TokenExchange)
// 2.2) buyBforA (buys TokenB for TokenA from from TokenExchange)

contract TokenExchange{
    //for simplicity deploy TokenA and TokenB from TokenExchange contract
    //initially all tokens minted by TokenA() and TokenB() belong to TokenExchange
    TokenA public proxyTA = new TokenA();
    TokenB public proxyTB = new TokenB();
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
    TokenA _proxyTA;

    receive() external payable { }

    //give  TokenExchange  address and TokenA address as parameters to the consructor
    constructor(address _adr0, address _adr1){
         _exchange = TokenExchange(_adr0);
         _proxyTA = TokenA(_adr1);
    }

    // step 1) buy token A for ethers from the exchange
    function buyForEthers(uint _vol) public returns(bool) {
        //address payable _to = payable(address(_exchange));
        require(_exchange.buyTokenForEther{value: _vol}("TA")==_vol, "transaction failed");
        return true;
    }

    // 2) after step 1) buy token B for token A
    function buyBforA(uint _vol) public returns(bool){
        //get available amount of TAs
        uint _balanceTA = _proxyTA.balanceOf(address(this));
        //check that the _vol amount of TBs could be bought 
        require(_vol <= _balanceTA, "can't buy that much TBs");
        //approve transfer of TAs for TBs for TokenExchange
        _proxyTA.approve(address(_exchange), _vol);
        // now buy TBs
        require(_exchange.buyB(_vol)==true, "transaction failed");
        return true;

    }

}