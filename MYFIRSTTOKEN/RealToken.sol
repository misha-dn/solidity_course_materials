// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "./ERC20.sol";
/*import "@openzeppelin/contracts@5.0.2/access/Ownable.sol";*/

contract MyFirstToken is ERC20 {
    address private _owner;

    error UnauthorizedAccount(address account);

    constructor(address initialOwner)
        ERC20("MyFirstToken", "MFT")
        /*Ownable(initialOwner)
        */
    {
        _owner = initialOwner;
        _mint(msg.sender, 100 * 10 ** decimals());
    }

    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != msg.sender) {
            revert UnauthorizedAccount(msg.sender);
        }
    }    

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
