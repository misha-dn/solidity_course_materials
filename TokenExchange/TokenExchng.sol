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

    //sells tokenA or tokenB for ethers 1:1
    function buyTokenForEther(string memory TokenCode) public payable{
        //msg.value = amount of ethers sent by a buyer
        //check which token is wanted  
        bool _tokenA = keccak256(abi.encodePacked(TokenCode))==keccak256(abi.encodePacked("TA"));
        bool _tokenB = keccak256(abi.encodePacked(TokenCode))==keccak256(abi.encodePacked("TB"));
        if( _tokenA){
            //check if the TokenExchange has enough tokens TA
            require(proxyTA.balanceOf(address(this)) >= msg.value, "Not enough TAs to sell for ethers, reverting");
            //send msg.value of TAs to the buyer
            require(proxyTA.transfer(msg.sender, msg.value)==true, "Transfer of TAs failed, reverting");
        }
        if( _tokenB){
            //check if the TokenExchange has enough tokens TA
            require(proxyTB.balanceOf(address(this)) >= msg.value, "Not enough TBs to sell for ethers, reverting");
            //send msg.value of TAs to the buyer
            require(proxyTB.transfer(msg.sender, msg.value)==true, "Transfer of TBs failed, reverting");                        
        }
        if(_tokenA && _tokenB == false){
            revert("wrong token code, reverting");
        }
        

    }

    
}