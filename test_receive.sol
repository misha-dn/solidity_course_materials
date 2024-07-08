// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// contract Owned {
//     address owner;
//     constructor() {
//         owner = msg.sender;
//     }
// }


contract Called {

    receive() external payable {
    }

    function showBalance() public view  returns(uint _balance) {
        _balance = address(this).balance;
    }
    
}

contract Caller {

    function pay() public payable {
    }

    //transfer to a given adr
    function sendToken(address _tp, uint _val) public payable {
        address payable _to = payable(address(_tp));
        _to.transfer(_val);
    }

    //transfer via low-level call
    function sendTknViaCall(address payable _to, uint _val) public payable {
        (bool succ,) = _to.call{value: _val}("");
        require(succ, "transaction failed");
    }

    //gas does not depend on call or transfer

    function showBalance() public view  returns(uint _balance) {
        _balance = address(this).balance;
    }    
}