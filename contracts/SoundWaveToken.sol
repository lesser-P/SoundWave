// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SoundWaveToken is ERC20 {
    address public owner;

    constructor() ERC20("SW", "SW") {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "SWToken ERR : msg.sender is not owner");
        _;
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}
