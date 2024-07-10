// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract data {

    address public owner;

    //uint address bool
    uint public val;
    address public my_contract_addr;
    bool public flag;
    //immutable address
    address public immutable some_address;
    //const
    uint public constant const_val = 123;
    //mapping
    mapping (address => uint) public customer_pmt;
    //dynamic array
    uint[] public arr;



    constructor() {
        owner = msg.sender;
    }

    //проверка подлинности владельца
    modifier chkOwner() {
        require(msg.sender == owner, "false owner");
        _;
    }

    //проверка 0 адреса
    modifier chkZeroAddr(address _newaddr) {
        require(_newaddr != address(0x0), "new owner is zero ");
        _;
    }

    
    //структура
    struct Balance {
        uint timestamp; //num of pmts by client
        uint amount; //paymnet value
        string client; //client name
    }
    //словарь структур
    mapping(address => Balance) public balances_dict;

    //массив структур
    Balance[] public balances_array;

    //вложенный маппинг
    mapping(address => mapping(uint => uint)) public ledger;

    //FUCTIONS
    //alter contract owner
    function newOwner(address _newaddr) public chkZeroAddr(_newaddr) {
        owner = _newaddr;
    }

    
    




}