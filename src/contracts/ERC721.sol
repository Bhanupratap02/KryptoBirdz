// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.0;

import "./ERC165.sol";
import "./interfaces/IERC721.sol";
import "./libraries/Counters.sol";
contract ERC721 is ERC165,IERC721{
    using SafeMath for uint256;
    using Counters for Counters.Counter;
 constructor(){
    _registerInterface(bytes4(keccak256('balanceOf(bytes4)')^keccak256('ownerOf(bytes4)')^keccak256('transferFrom(bytes4)')));
}

    // mapping  from token id to owner
    mapping(uint256 => address) private _tokenOwner;
    // mapping from owner to no of owned tokens
    mapping(address => Counters.Counter) private _ownedTokensCount;

    // Mapping from token id to aproved addresses
    mapping(uint256 => address) private _tokenApprovals;

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) public override view returns(uint256){
      require(_owner != address(0),"owner query non-existent token");
        return _ownedTokensCount[_owner].current();
    }


     /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) public override view returns(address){
        address owner = _tokenOwner[_tokenId];
          require(owner != address(0),"owner query non-existent token");
        return owner;
    }
    
    function _exists(uint256 tokenId) internal view returns(bool){
        // setting the address of token id to variable owner.if tokenid have an address it means token alredy exists
        address owner = _tokenOwner[tokenId];
        // return truthfullness that the address is not zero or valid
        return owner!=address(0);
    }
    function _mint(address to,uint256 tokenId) internal virtual {
        //require the address is not zero ie valid
        require(to != address(0),"ERC721: minting to the zero address");
        // require tokenid does  not exist
        require(!_exists(tokenId),"ERC721 token already minted");
        // we are adding a new address with a token id for minting
        _tokenOwner[tokenId] = to;
        //keeping track of each address that is minting and adding one i.e. keep tract which address hold how many tokens
        _ownedTokensCount[to].increment(); 

        emit Transfer(address(0), to, tokenId);
    }
    /// @notice Transfer ownership of an NFT 
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal{
        require(_to != address(0),"Error- Erc721 Transfer to the zero address");
        require(ownerOf(_tokenId) == _from,"Trying to transfer a token the address doesnot own");

        // update the balance of the address _from
        _ownedTokensCount[_from].decrement();
        // update the balance of the address _to
        _ownedTokensCount[_to].increment();
        // add the token id  the address receiving the token
      _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }
      function transferFrom(address _from, address _to, uint256 _tokenId) public override {
        require(isApprovedOrOwner(msg.sender,_tokenId));
         _transferFrom(_from, _to, _tokenId);
      }



   function approve(address _to,uint256 tokenId) public {
    address owner = ownerOf(tokenId);
    require(_to != owner,"Error-Approval to the owner");
    require(msg.sender == owner,"Current caller is not the owner");
    _tokenApprovals[tokenId] = _to;

    emit Approved(owner,_to,tokenId);
   }


 function isApprovedOrOwner(address spender, uint256 tokenId)internal view returns(bool){
 require(_exists(tokenId),"token doesnot exists");
 address owner = ownerOf(tokenId);
 address approved = _tokenApprovals[tokenId];
 return(spender == owner || spender == approved );
 }
}