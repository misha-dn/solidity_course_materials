// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "./TokenA.sol";
import "./TokenB.sol";

contract TokenExchange{
    //for simplicity deploy TokenA and TokenB from TokenExchange contract
    //pass them TokenExchange address for transferring initial token balance to the exchange
    TokenA internal proxyTA = new TokenA(address(this));
    TokenB internal proxyTB = new TokenB(address(this));
    mapping(string => uint) public TokenBalance;

    constructor(){
        //record starting balance of tokens
        TokenBalance["TA"] = proxyTA.balanceOf(address(this));
        TokenBalance["TB"] = proxyTB.balanceOf(address(this));
    }

    //sells tokenA or tokenB for ethers 1:1
    function buyTokenForEther(string memory TokenCode) public payable returns(uint){
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
            TokenBalance["TA"] -= msg.value;            
            tokens_transfered = proxyTB.balanceOf(msg.sender);                        
        }
        if(_tokenA == false  && _tokenB == false){
            revert("wrong token code, reverting");
        }
        return tokens_transfered;
    }

    // function showBalance(string memory TokenCode) public view returns(int) {
    //     bool _tokenA = keccak256(abi.encodePacked(TokenCode))==keccak256(abi.encodePacked("TA"));
    //     bool _tokenB = keccak256(abi.encodePacked(TokenCode))==keccak256(abi.encodePacked("TB"));
    //     int r = -1;        
    //     if(_tokenA){
    //         r = int(proxyTA.balanceOf(address(this)));
    //     }
    //     if(_tokenB){
    //         r = int(proxyTA.balanceOf(address(this)));
    //     }     
    //     return r;   
    // }

    // function showCode(string memory code) public pure returns(bytes32, bytes32){
    //     bytes memory r0 = abi.encodePacked("TA");
    //     bytes memory r1 = abi.encodePacked(code);
    //     return (keccak256(r0), keccak256(r1));
    // }
    
}