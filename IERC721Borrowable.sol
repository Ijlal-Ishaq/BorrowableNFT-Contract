// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IERC721Borrowable is IERC721 {

    event Borrowed(address indexed from, address indexed to, uint256 indexed tokenId, uint256 borrowedTill);

    function lendToken(uint256 _tokenId , address _borrower , uint256 _borrowedTill) external;

    function isBorrowed(uint256 _tokenId) external view returns (bool);

}
