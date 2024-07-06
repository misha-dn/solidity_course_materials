// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract lesson_3 {

    address owner;

    //Payment of each client
    struct Payment {
        uint Amount;
        address From;
        uint timestamp;
    }

    enum pmtStatus {
        paid,
        delivered,
        pending
    }

    constructor() {
        owner = msg.sender;
    }

    modifier chkOwner() {
        require(msg.sender == owner, "false owner");
        _;
    }

    modifier chkZeroAddr(address _newaddr) {
        require(_newaddr != address(0x0), "new owner is zero ");
        _;
    }

    function newOwner(address _newaddr) public chkOwner chkZeroAddr(_newaddr) {
        owner = _newaddr;
    }

    function showBalance() public view chkOwner returns(uint _balance) {
        _balance = address(this).balance;
    }

    function pay() public payable {
    }

    //prints out zero address for testing
    function showZaddr() public pure returns(address _adr) {
        _adr = address(0x0);
    }
}