// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WETH is ERC20 {
    constructor() payable ERC20("WETH", "WETH") {}

    event GetEth(address indexed account, uint256 indexed amount);

    receive() external payable {
        emit GetEth(msg.sender, msg.value);
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
