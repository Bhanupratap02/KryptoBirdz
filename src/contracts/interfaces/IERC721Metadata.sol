// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.0;


///  the ERC-165 identifier for this interface is 0x5b5e139f.
interface IERC721Metadata {
 
    function name() external view returns (string memory _name);

    function symbol() external view returns (string memory _symbol);

  
}