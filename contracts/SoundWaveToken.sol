// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SoundWaveToken is ERC20 {
    mapping(address => bool) owners;

    constructor() payable ERC20("SW", "SW") {
        owners[msg.sender] = true;
    }

    event GetEth(address indexed account, uint256 indexed amount);

    receive() external payable {
        emit GetEth(msg.sender, msg.value);
    }

    modifier onlyOwner() {
        require(owners[msg.sender], "SWToken ERR : msg.sender is not owner");
        _;
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function setOwner(address to, bool flag) public onlyOwner {
        owners[to] = flag;
    }
}
