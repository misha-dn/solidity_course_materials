// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract MyShop {

    address public owner;
    mapping (address => uint) public customer_pmt;

    constructor() {
        owner = msg.sender;
    }

    function payForItem() public payable {
        customer_pmt[msg.sender] = msg.value;
    }

    function withdrawAll() public {
        address payable _to = payable(owner);
        address _thisContract = address(this);
        _to.transfer(_thisContract.balance);
    }
}