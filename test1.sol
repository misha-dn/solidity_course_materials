// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract data{
        
    address public owner;

    //uint address bool
    uint public val;
    address public some_address;
    bool public flag;
    //immutable address
    uint public immutable my_immut_uint;
    //const
    uint public constant const_val = 123;
    //mapping
    mapping (uint => uint) public customer_pmt;
    //dynamic array
    uint[] public pmt_num = [1,2,3];
    uint[] public pmt_val = [100,20,350];

    constructor(uint _externUint) {
        owner = msg.sender;
        //function to set immutable in constructor
        my_immut_uint = setUint(_externUint);
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

    mapping(uint => string) public log;

    //FUCTIONS
    //alter contract owner
    function newOwner(address _newaddr) public chkZeroAddr(_newaddr) {
        owner = _newaddr;
    }

    //function to set immutable in constructor
    function setUint(uint _source) public pure returns(uint){
        return _source;
    }  

    //add element to a dynamic array
    function addDynamArr(uint _newnum) public {
        pmt_num.push(_newnum);
    }

    //delete element from a dynamic array
    function delDynamArr() public {
        pmt_num.pop();
    }

    // add element to a nested mapping
    function addtoMapping(address _from) public {

         for(uint i=0; i<2; i++){
            ledger[_from][pmt_num[i]] = pmt_val[i];
         }
    }

    //delete alement from a nested mapping
    function delfromMapping(address _from) public {

        for(uint i=0; i<2; i++){
            delete ledger[_from][pmt_num[i]];
         }
    }

    //add struct to a mapping of structs
    function addStructToMapping(uint _timestmp, uint _amount, string memory _client, address _key) public {
        Balance memory _balance = Balance({timestamp: _timestmp, amount: _amount, client: _client});
        balances_dict[_key] = _balance;
    }

    //add struct to an array of sctructs
    function addStructToArray(uint _timestmp, uint _amount, string memory _client) public {
        Balance memory _balance = Balance({timestamp: _timestmp, amount: _amount, client: _client});
        balances_array.push(_balance);
    }

    //add string to a mapping of strings
    function addMsgToLog(uint _timestmp) public {
        string memory _msg = "1 eth is added to your balance";
        log[_timestmp] = _msg;
    } 

}