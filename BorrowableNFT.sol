// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721Borrowable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BorrowableNFT is ERC721Borrowable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenId;

    constructor() ERC721Borrowable("BorrowableNFT", "B-NFT"){}

    function mint(address _to) external {
        _tokenId.increment();
        _safeMint(_to, _tokenId.current());
    }

    function totalSuppy() public view returns(uint256){
        return _tokenId.current();
    }

}

