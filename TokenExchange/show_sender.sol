// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

// test who is msg.sender if running a contract A function from contract B

contract A{
    address public owner;

    constructor(){
        owner = address(this);
    }

    function showSenderA() public view returns(address){
        return(msg.sender);
    }
    function showOwnerA() public view returns(address){
        return(owner);        
    }    

}

contract B{
    A public token;
    address public owner;

    constructor(){
        token = new A();
        owner = msg.sender;
    }

    function showSenderB() public view returns(address){
        //token.showSenderA() = address of the contract that calls token.showSenderA() (i.e. contract B)
        // NOT the address of the account that calls showSenderB()
        return(token.showSenderA());
    }
    function showOwnerB() public view returns(address){
        return(token.showOwnerA());
    }    
}