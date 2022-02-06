// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "hardhat/console.sol";

contract CustomERC721 is
    Initializable,
    ERC721Upgradeable,
    ERC721EnumerableUpgradeable,
    ERC721URIStorageUpgradeable,
    PausableUpgradeable,
    OwnableUpgradeable,
    ERC721BurnableUpgradeable,
    UUPSUpgradeable
{
    using CountersUpgradeable for CountersUpgradeable.Counter;

    CountersUpgradeable.Counter private _tokenIdCounter;

    struct Player {
        uint256 class;
        uint256 level;
        uint256 power;
        bool isPlaying;
    }

    mapping(uint256 => Player) players;

    constructor() initializer {}

    function initialize() public initializer {
        //Add your token name and symbol.
        __ERC721_init("NAME", "SYMBOL");
        __ERC721Enumerable_init();
        __ERC721URIStorage_init();
        __Pausable_init();
        __Ownable_init();
        __ERC721Burnable_init();
        __UUPSUpgradeable_init();
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://your-base-uri/";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);

        players[tokenId] = Player({
            class: 1,
            level: 1,
            power: 1,
            isPlaying: false
        });
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    )
        internal
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
        whenNotPaused
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyOwner
    {}

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId)
        internal
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function startPlaying(uint256 tokenId)
        public
        onlyHolderOrOwner(tokenId)
        returns (Player memory player)
    {
        require(isPlaying(tokenId) == false, "Player is already playing.");

        players[tokenId].isPlaying = true;
        return players[tokenId];
    }

    function stopPlaying(uint256 tokenId)
        public
        onlyHolderOrOwner(tokenId)
        returns (Player memory player)
    {
        require(isPlaying(tokenId) == true, "Player is not playing.");

        players[tokenId].isPlaying = false;
        return players[tokenId];
    }

    function isPlaying(uint256 tokenId) public view returns (bool) {
        return players[tokenId].isPlaying;
    }

    function getPlayerInfo(uint256 tokenId)
        public
        view
        returns (Player memory player)
    {
        return players[tokenId];
    }

    function upgrade(uint256 tokenId)
        public
        onlyHolderOrOwner(tokenId)
        returns (Player memory player)
    {
        players[tokenId].level = players[tokenId].level + 1;
        players[tokenId].power = players[tokenId].power + 1;
        return players[tokenId];
    }

    modifier onlyHolderOrOwner(uint256 tokenId) {
        address sender = _msgSender();
        require(
            ownerOf(tokenId) == sender || sender == owner(),
            "You do not own this token."
        );
        _;
    }
}
