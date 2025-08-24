// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, ERC721URIStorage, Ownable, ReentrancyGuard {
    uint256 private _tokenIds;
    // NFT 元数据基础 URI
    string private _baseTokenURI;
    
    // 每个地址最多可以铸造的 NFT 数量
    uint256 public maxMintPerAddress = 5;
    
    // 记录每个地址已铸造的 NFT 数量
    mapping(address => uint256) public mintedCount;
    
    // 铸造事件
    event NFTMinted(address indexed to, uint256 indexed tokenId, string tokenURI);

    constructor(
        string memory name,
        string memory symbol,
        string memory baseTokenURI
    ) ERC721(name, symbol) Ownable(msg.sender) {
        _baseTokenURI = baseTokenURI;
    }

    /**
     * @dev 铸造 NFT
     * @param to 接收 NFT 的地址
     * @param _tokenURI NFT 的元数据 URI
     */
    function mintNFT(address to, string memory _tokenURI) 
        external 
        onlyOwner 
        returns (uint256) 
    {
        require(to != address(0), "Invalid recipient address");
        require(bytes(_tokenURI).length > 0, "Token URI cannot be empty");
        require(mintedCount[to] < maxMintPerAddress, "Exceeds max mint limit per address");

        _tokenIds++;
        uint256 newTokenId = _tokenIds;

        _safeMint(to, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);
        
        mintedCount[to]++;
        
        emit NFTMinted(to, newTokenId, _tokenURI);
        
        return newTokenId;
    }

    /**
     * @dev 批量铸造 NFT
     * @param to 接收 NFT 的地址
     * @param tokenURIs NFT 元数据 URI 数组
     */
    function batchMintNFT(address to, string[] memory tokenURIs) 
        external 
        onlyOwner 
        returns (uint256[] memory) 
    {
        require(to != address(0), "Invalid recipient address");
        require(tokenURIs.length > 0, "Token URIs array cannot be empty");
        require(
            mintedCount[to] + tokenURIs.length <= maxMintPerAddress, 
            "Exceeds max mint limit per address"
        );

        uint256[] memory newTokenIds = new uint256[](tokenURIs.length);

        for (uint256 i = 0; i < tokenURIs.length; i++) {
            require(bytes(tokenURIs[i]).length > 0, "Token URI cannot be empty");

            _tokenIds++;
            uint256 newTokenId = _tokenIds;

            _safeMint(to, newTokenId);
            _setTokenURI(newTokenId, tokenURIs[i]);
            
            newTokenIds[i] = newTokenId;
        }

        mintedCount[to] += tokenURIs.length;
        
        return newTokenIds;
    }

    /**
     * @dev 设置每个地址的最大铸造数量
     * @param maxMint 最大铸造数量
     */
    function setMaxMintPerAddress(uint256 maxMint) external onlyOwner {
        require(maxMint > 0, "Max mint must be greater than 0");
        maxMintPerAddress = maxMint;
    }

    /**
     * @dev 设置基础 URI
     * @param baseURI 新的基础 URI
     */
    function setBaseURI(string memory baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

    /**
     * @dev 获取 NFT 的完整 URI
     * @param tokenId NFT 的 ID
     */
    function tokenURI(uint256 tokenId) 
        public 
        view 
        override(ERC721, ERC721URIStorage) 
        returns (string memory) 
    {
        return super.tokenURI(tokenId);
    }

    /**
     * @dev 获取当前已铸造的 NFT 总数
     */
    function totalSupply() external view returns (uint256) {
        return _tokenIds;
    }

    /**
     * @dev 检查 NFT 是否存在
     * @param tokenId NFT 的 ID
     */
    function exists(uint256 tokenId) external view returns (bool) {
        return ownerOf(tokenId) != address(0);
    }

    /**
     * @dev 获取地址拥有的 NFT 列表
     * @param owner 地址
     */
    function tokensOfOwner(address owner) external view returns (uint256[] memory) {
        uint256 tokenCount = balanceOf(owner);
        uint256[] memory tokens = new uint256[](tokenCount);
        
        uint256 currentIndex = 0;
        for (uint256 i = 1; i <= _tokenIds; i++) {
            if (ownerOf(i) == owner) {
                tokens[currentIndex] = i;
                currentIndex++;
            }
        }
        
        return tokens;
    }

    // 重写 supportsInterface 函数以兼容多重继承
    function supportsInterface(bytes4 interfaceId) 
        public 
        view 
        override(ERC721, ERC721URIStorage) 
        returns (bool) 
    {
        return super.supportsInterface(interfaceId);
    }
}