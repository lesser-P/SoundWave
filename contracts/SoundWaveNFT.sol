// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "hardhat/console.sol";
import "./SoundWaveToken.sol";

contract SoundWaveNFT is ERC721URIStorage, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenId;
    Counters.Counter private _showId;

    mapping(address => bool) executor;
    string base = "test";
    address private admin;

    SoundWaveToken soundWaveToken;

    // 通过showid和座位id号定位到持有人
    mapping(uint256 => mapping(uint256 => address)) showIdToSeatNoToUser;
    // 通过showId获得show
    mapping(uint256 => ShowInfo) showIdToShowInfo;
    // 通过地址得到SoundWave的信息
    mapping(uint256 => SoundTicket) tokenIdToSoundTicket;
    //showId下ticket
    mapping(uint256 => SoundTicket[]) showIdToSoundTicket;

    modifier onlyExecutor() {
        require(executor[msg.sender], "no executor");
        _;
    }
    modifier onlyAdmin() {
        require(msg.sender == admin, "not admin");
        _;
    }

    struct SoundTicket {
        uint256 showId;
        address _owner;
        uint256 _ticketNo;
        uint256 changeHandsPrice; //转手价格
    }
    struct ShowInfo {
        uint256 showId;
        string showName;
        string showLead; //主角
        string description; //简介
        uint256 ticketNum; //票数总数
        uint256 sellStartTime; //售票时间
        uint256 price; //eth
        bool changeHands; //转手开关
        uint256 tickNo;
    }

    constructor(address token) ERC721("SWNFT", "SWNFT") {
        soundWaveToken = SoundWaveToken(token);
        admin = msg.sender;
    }

    function mintFromExecutor(
        address _to,
        uint256 _showId,
        uint256 _ticketNo
    ) external nonReentrant onlyExecutor returns (bool) {
        require(_to != address(0), "address is Zero");
        return createTicket(_to, _showId, _ticketNo);
    }

    // 创建表演
    function createShow(
        ShowInfo memory showInfo
    ) public nonReentrant onlyOwner returns (uint256) {
        _showId.increment();
        uint256 showId = _showId.current();
        require(
            bytes(showIdToShowInfo[showId].showName).length == 0,
            "showId was used"
        );
        showInfo.showId = _showId.current();
        showIdToShowInfo[showId] = showInfo;
        return showId;
    }

    // 创建门票
    function createTicket(
        address _to,
        uint256 _showId,
        uint256 _ticketNo
    ) internal returns (bool) {
        require(
            showIdToShowInfo[_showId].sellStartTime <= block.timestamp,
            "not right time"
        );
        require(
            //判断showid是否存在
            showIdToSeatNoToUser[_showId][_ticketNo] == address(0),
            "the ticketNo was chosed"
        );
        //判断该演唱会的门票是否支持转手
        SoundTicket memory ticket;
        ShowInfo memory info = showIdToShowInfo[_showId];
        ticket.showId = _showId;
        ticket._ticketNo = _ticketNo;
        ticket._owner = msg.sender;
        if (info.changeHands) {
            ticket.changeHandsPrice = info.price;
        }
        ticket.changeHandsPrice = type(uint256).max;
        //保存门票信息
        showIdToSeatNoToUser[_showId][_ticketNo] = msg.sender;
        mintTicket(_to, ticket);
        return true;
    }

    function mintTicket(
        address _to,
        SoundTicket memory ticket
    ) internal onlyExecutor returns (uint256) {
        _tokenId.increment();
        uint256 nowTokenId = _tokenId.current();
        require(
            showIdToShowInfo[ticket.showId].ticketNum >=
                showIdToSoundTicket[ticket.showId].length,
            "not enought tickets"
        );
        //保存对应信息
        tokenIdToSoundTicket[nowTokenId] = ticket;
        showIdToSoundTicket[ticket.showId].push(ticket);
        _safeMint(_to, nowTokenId);
        string memory url = string(abi.encodePacked(base, "/", nowTokenId));
        _setTokenURI(nowTokenId, url);
        return nowTokenId;
    }

    function _setBaseURI(
        string memory baseURI
    ) public onlyAdmin returns (string memory) {
        base = baseURI;
        return base;
    }

    function getSoundTick(
        uint256 tokenId
    ) public view returns (SoundTicket memory) {
        return tokenIdToSoundTicket[tokenId];
    }

    function getShowInfo(uint256 showId) public view returns (ShowInfo memory) {
        return showIdToShowInfo[showId];
    }

    function setExecutor(address to, bool flag) public onlyAdmin {
        executor[to] = flag;
    }

    function setAdmin(address to) public onlyAdmin {
        admin = to;
    }

    function claim(uint256 _tokenId) public returns (bool) {
        // 销毁NFT提取奖励
        _burn(_tokenId);
        SoundTicket memory ticket = tokenIdToSoundTicket[_tokenId];

        soundWaveToken.mint(
            ticket._owner,
            ((showIdToShowInfo[ticket.showId].price * 10000) / 2) / 10000
        );
    }
}
