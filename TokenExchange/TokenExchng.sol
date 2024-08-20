// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "./TokenA.sol";
import "./TokenB.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";




contract TokenExchange{

    using SafeERC20 for *;

    TokenA internal proxyTA;
    TokenB internal proxyTB;

    mapping(string => uint) public TokenBalance;

    constructor (TokenA adr1, TokenB adr2){
        //token addresses are passed to the constructor
        proxyTA = adr1;
        proxyTB = adr2;
    }

    //sells tokenA or tokenB for ethers 1:1

    function buyTokenForEther(address _token) public payable returns(int){
        //msg.value = amount of ethers sent by a buyer
        //check which token is wanted  
        bool _tokenA = _token == address(proxyTA);
        bool _tokenB = _token == address(proxyTB);
        int  _tokens_transfered = -1;
        if( _tokenA){
            //check if TokenExchange has enough tokens TA
            require(proxyTA.balanceOf(address(this)) >= msg.value, "Not enough TAs to sell for ethers, reverting");
            //send msg.value of TAs to the buyer, automatically reverts on failure
            proxyTA.safeTransfer(msg.sender, msg.value);            
            //reflect the change in token balance of the TokenExchange
            TokenBalance["TA"] -= msg.value;
            _tokens_transfered = int(proxyTA.balanceOf(msg.sender));            
        }
        if( _tokenB){
            //check if TokenExchange has enough tokens TB
            require(proxyTB.balanceOf(address(this)) >= msg.value, "Not enough TBs to sell for ethers, reverting");
            //send msg.value of TBs to the buyer, automatically reverts on failure
            proxyTB.safeTransfer(msg.sender, msg.value); 
            //reflect the change in token balance of the TokenExchange
            TokenBalance["TB"] -= msg.value;
            _tokens_transfered = int(proxyTB.balanceOf(msg.sender));                                     
        }
        //if wrong token need to revert in order to roll back ethers to the buyer
        require(_tokens_transfered >= 0, "wrong token, reverting");

        return _tokens_transfered;
    }


    function buyToken(address _TA, address _TB, uint _amount) public returns(uint){
        //check which token is wanted  
        bool _tokenA = _TA == address(proxyTA); //buy TA for TB
        bool _tokenB = _TB == address(proxyTB); //buy TB for TA
        uint _tokens_transfered = 0;
        if (_tokenA) { //if TA is wanted
            //transfer _amount of TBs from msg.sender to TokenExchange
            proxyTB.safeTransferFrom(msg.sender, address(this), _amount);
            TokenBalance["TB"] += _amount;
            //transfer _amount of TAs to msg.sender (the buyer)
            require(proxyTA.transfer(msg.sender, _amount), "cannot transfer TAs to the buyer");
            TokenBalance["TA"] -= _amount;
            _tokens_transfered = _amount;
        }
        if (_tokenB) { //if TB is wanted
            //transfer _amount of TAs from msg.sender to TokenExchange
            proxyTA.safeTransferFrom(msg.sender, address(this), _amount);
            TokenBalance["TA"] += _amount;
            //transfer _amount of TBs to msg.sender (the buyer)
            require(proxyTA.transfer(msg.sender, _amount), "cannot transfer TBs to the buyer");
            TokenBalance["TB"] -= _amount;
            _tokens_transfered = _amount;
        }      
        return _tokens_transfered; 
    }    

    

}