// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.0;
interface IERC721  {
    event Transfer(
        address indexed from,
         address indexed to,
         uint256 indexed tokenId);
    event Approved(
      address indexed owner,
      address indexed approved,
      uint256 indexed tokenid);

   


    function balanceOf(address _owner) external view returns (uint256);

 
    function ownerOf(uint256 _tokenId) external view returns (address);

  

    

   
    function transferFrom(address _from, address _to, uint256 _tokenId) external ;

    /// @notice Change or reaffirm the approved address for an NFT
    /// @dev The zero address indicates there is no approved address.
    ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
    ///  operator of the current owner.
    /// @param _approved The new approved NFT controller
    /// @param _tokenId The NFT to approve
    // function approve(address _approved, uint256 _tokenId) external payable;


  

}