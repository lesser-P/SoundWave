// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./SoundWaveNFT.sol";

contract buyTicketLogic is Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _showId;
    SoundWaveNFT soundWaveNFT;
    address private admin;

    modifier onlyAdmin() {
        require(msg.sender == admin, "not authorization");
        _;
    }

    struct ShowInfo {
        uint256 showId;
        string showName;
        string showLead; //主角
        string description; //简介
        uint256 ticketNum; //票数总数
        uint256 remqty; //剩余票数
        uint256 sellStartTime; //售票时间
        uint256 price; //eth
        bool changeHands; //转手开关
        uint256 tickNo;
    }

    //门票信息
    struct SoundTicket {
        uint256 showId;
        address _owner;
        uint256 _tickNo;
        uint256 showTime; //演出时间
        uint256 changeHandsPrice; //转手价格
        uint256 tokenId;
    }

    mapping(uint256 => ShowInfo) showIdToInfo;
    mapping(uint256 => SoundTicket[]) showIdToTicket;
    mapping(address => SoundTicket[]) userToSoundTicket;
    mapping(uint256 => address) ticketNoToAddress;
    mapping(uint256 => mapping(uint256 => SoundTicket)) tokenIdToShowIdToSoundTicket;

    event CreateTick(
        address indexed user,
        uint256 indexed amount,
        SoundTicket ticket
    );
    event CreateShowInfo(address indexed user, ShowInfo showinfo);
    event GetETH(address indexed user, uint256 amount, uint256 timestamp);

    receive() external payable {
        emit GetETH(msg.sender, msg.value, block.timestamp);
    }

    constructor(address nftAddress) {
        soundWaveNFT = SoundWaveNFT(nftAddress);
        admin = msg.sender;
    }

    function createShow(
        string memory _showName,
        string memory _showLead,
        string memory _description,
        uint256 _ticketNum,
        uint256 _sellStartTime,
        uint256 _price,
        bool _changeHands,
        uint256 _tickNo
    ) public payable onlyOwner returns (ShowInfo memory) {
        require(msg.value == 0.01 ether, "not match eth");
        _showId.increment();
        uint256 showId = _showId.current();
        ShowInfo memory _showInfo;
        _showInfo.showId = showId;
        _showInfo.showName = _showName;
        _showInfo.showLead = _showLead;
        _showInfo.description = _description;
        _showInfo.ticketNum = _ticketNum;
        _showInfo.sellStartTime = _sellStartTime;
        _showInfo.price = _price;
        _showInfo.changeHands = _changeHands;
        _showInfo.tickNo = _tickNo;
        showIdToInfo[showId] = _showInfo;

        return _showInfo;
    }

    function createTicks(
        address to,
        uint256 amount,
        SoundTicket memory ticketInfo
    ) external payable {
        //判断
        require(to != address(0), "BUY ERR: address is zero");
        require(amount > 0, "amount is zero");
        address userAddr = ticketNoToAddress[ticketInfo._tickNo];
        require(userAddr == address(0), "tickNo is used");
        //判断金额是否足够
        uint256 showBasePrice = showIdToInfo[ticketInfo.showId].price;
        require(showBasePrice * amount == msg.value, "not right eth number");
        for (uint i = 0; i < amount; i++) {
            _createTicket(to, ticketInfo);
        }
    }

    function _createTicket(
        address _to,
        SoundTicket memory ticketInfo
    ) internal nonReentrant {
        ShowInfo memory info = showIdToInfo[ticketInfo.showId];
        require(info.showId > 0, "ticketInfo not right showId");
        require(info.sellStartTime <= block.timestamp, "not right time");
        //mint
        uint256 _tokenId = soundWaveNFT.mint(_to);
        ticketInfo.tokenId = _tokenId;
        //添加到showIdToTicket保存
        showIdToTicket[ticketInfo.showId].push(ticketInfo);
        //保存这个座位号对应的地址
        ticketNoToAddress[ticketInfo._tickNo] = msg.sender;
        //添加到userToSound Ticket；
        userToSoundTicket[msg.sender].push(ticketInfo);
        tokenIdToShowIdToSoundTicket[_tokenId][ticketInfo.showId] = ticketInfo;
    }

    function setAdmin(address _admin) public onlyAdmin {
        admin = _admin;
    }

    function tokenIdGetTicketInfo(
        uint256 tokenId,
        uint256 showId
    ) public view returns (SoundTicket memory) {
        return tokenIdToShowIdToSoundTicket[tokenId][showId];
    }

    function claimAll() public onlyAdmin returns (uint256) {
        uint256 eth = address(this).balance;
        payable(admin).transfer(eth);
        return eth;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
