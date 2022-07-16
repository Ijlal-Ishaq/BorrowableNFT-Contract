// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./IERC721Borrowable.sol";

abstract contract ERC721Borrowable is ERC721, IERC721Borrowable {
    
    struct BorrowDetail {
        address borrower;
        uint borrowedTill;
    }

    mapping(uint => BorrowDetail) private borrowDetails;

    constructor(string memory name, string memory symbol) ERC721(name, symbol){}

    function lendToken(uint _tokenId , address _borrower , uint _borrowedTill) external virtual override {
        require(_isApprovedOrOwner(msg.sender,_tokenId) == true , "You don't have the rights.");
        require(_borrowedTill > block.timestamp , "The end time has passed.");
        require(isBorrowed(_tokenId) == false , "Token is already borrowed.");

        BorrowDetail memory obj = BorrowDetail(_borrower,_borrowedTill);
        borrowDetails[_tokenId] = obj;

        emit Borrowed(msg.sender,_borrower,_tokenId,_borrowedTill);
    }

    function isBorrowed(uint _tokenId) public view virtual override returns (bool){
        if(borrowDetails[_tokenId].borrowedTill >= block.timestamp){
            return true;
        }else{
            return false;
        }
    }

    function safeTransferFrom(address from , address to , uint256 _tokenId) public virtual override(ERC721, IERC721){
        require(isBorrowed(_tokenId) == false , "Token is borrowed.");
        super.safeTransferFrom(from,to,_tokenId);
    }

    function safeTransferFrom(address from , address to , uint256 _tokenId , bytes memory _data) public virtual override(ERC721, IERC721) {
        require(isBorrowed(_tokenId) == false , "Token is borrowed.");
        super.safeTransferFrom(from,to,_tokenId,_data);
    }

    function transferFrom(address from , address to , uint256 _tokenId) public virtual override(ERC721, IERC721) {
        require(isBorrowed(_tokenId) == false , "Token is borrowed.");
        super.transferFrom(from,to,_tokenId);
    }

    function ownerOf(uint256 _tokenId) public view virtual override(ERC721, IERC721) returns (address) {
        if(isBorrowed(_tokenId)){
            return borrowDetails[_tokenId].borrower;
        }else{
            return super.ownerOf(_tokenId);
        }
    }
    
}
