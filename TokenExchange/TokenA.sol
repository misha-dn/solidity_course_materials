// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
/*import "@openzeppelin/contracts@5.0.2/access/Ownable.sol";*/

contract TokenA is ERC20 {
    address public _owner;

    //constructor takes the address of the token exchange contract
    constructor()
        ERC20("TokenA", "TA")

    {
        _owner = msg.sender;
        //mint initial volume of tokens TA to the _owner
        _mint(msg.sender, 100 * 10 ** decimals());

    }

 
}
