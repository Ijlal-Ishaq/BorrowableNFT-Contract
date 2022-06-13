// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BorrowableNFT is ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private tokenId;
    
    struct BorrowDetail {
        address borrower;
        uint timestamp;
    }

    mapping(uint=>BorrowDetail) private borrowDetails;

    constructor() ERC721("FractionalNFT", "F-NFT") {
        tokenId.increment();
    }

    function lendingToken(uint _tokenId , address _borrower , uint _endTime) external {
        require(_isApprovedOrOwner(msg.sender,_tokenId) == true , "You don't have the rights.");
        require(_endTime > block.timestamp , "The end time has passed.");
        require(isBorrowed(_tokenId) == false , "Token is already borrowed.");

        BorrowDetail memory obj = BorrowDetail(_borrower,_endTime);
        borrowDetails[_tokenId] = obj;

    }

    function isBorrowed(uint _tokenId) public view returns (bool){
        if(borrowDetails[_tokenId].timestamp >= block.timestamp){
            return true;
        }else{
            return false;
        }
    }

    function mint() external {
        _safeMint(msg.sender , tokenId.current());
    }

    function safeTransferFrom(address from , address to , uint256 _tokenId) public virtual override {
        require(isBorrowed(_tokenId) == false , "Token is borrowed.");
        super.safeTransferFrom(from,to,_tokenId);
    }

    function safeTransferFrom(address from , address to , uint256 _tokenId , bytes memory _data) public virtual override {
        require(isBorrowed(_tokenId) == false , "Token is borrowed.");
        super.safeTransferFrom(from,to,_tokenId,_data);
    }

    function transferFrom(address from , address to , uint256 _tokenId) public virtual override {
        require(isBorrowed(_tokenId) == false , "Token is borrowed.");
        super.transferFrom(from,to,_tokenId);
    }

    function ownerOf(uint256 _tokenId) public view virtual override returns (address) {
        if(isBorrowed(_tokenId)){
            return borrowDetails[_tokenId].borrower;
        }else{
            return super.ownerOf(_tokenId);
        }
    }
    
}