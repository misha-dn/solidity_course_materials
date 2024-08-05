// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "./ERC20.sol";
/*import "@openzeppelin/contracts@5.0.2/access/Ownable.sol";*/

contract TokenB is ERC20 {
    address private _owner;

    //constructor takes the address of the token exchange contract
    constructor(address tokenEx)
        ERC20("TokenB", "TB")

    {
        _owner = msg.sender;
        //mint initial volume of tokens TB
        mint(100 * 10 ** decimals());
        //send initial amount of TB for the tokenExchange
        initExchange(tokenEx, 10 * 10 ** decimals());

    }

    function owner() public view returns (address) {
        return _owner;
    }
 
    modifier onlyOwner() {
        require(_owner == msg.sender, "UnauthorizedAccount");
        _;
    }

    function mint(uint256 value) public onlyOwner{
        _mint(msg.sender, value * 10 ** decimals());
    }

    function initExchange(address tokenEx, uint256 initvol) internal onlyOwner{
        require(tokenEx != address(0), "InvalidExchangeAddress");
        transfer(tokenEx, initvol);
    }

}

contract TokEx{
    TokenB public _token;

    constructor(TokenB token){
        _token = TokenB(token);
    }

    function approve_other() public {
        /*IERC20 ex_contract = IERC20(address(this));*/
        _token.approve(address(this), 10);

    }
}
