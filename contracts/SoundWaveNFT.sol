// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract SoundWaveNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenId;

    struct SoundTicket {
        uint256 showId;
        address _owner;
        uint256 _tickNo;
        uint256 showTime; //演出时间
        uint256 changeHandsPrice; //转手价格
    }

    constructor() ERC721("SWNFT", "SWNFT") {}

    function mint(address _to) public onlyOwner returns (uint256) {
        uint256 nowTokenId = _tokenId.current();
        _tokenId.increment();
        _mint(_to, nowTokenId);
        return nowTokenId;
    }
}
