// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.0;
import "./ERC721.sol";
import "./interfaces/IERC721Enumerable.sol";
contract ERC721Enumberable is IERC721Enumerable, ERC721{

   constructor(){
    _registerInterface(bytes4(keccak256('totalSupply(bytes4)')^keccak256('tokenByIndex(bytes4)')^keccak256('tokenOfOwnerByIndex(bytes4)')));
}

  uint256[] private _allTokens;

  // mapping from tokenId to position in _allTokens array
   mapping(uint256 => uint256) private _allTokensIndex;
  // mapping of owner to list of all owned token ids
   mapping(address => uint256[]) private _ownedTokens;
  // mapping from tokenId to  index of the tokenID of that owner in _ownedTokens array
  // or token id to position in the _ownedTokens array of for a particular owner 
 mapping(uint256 => uint256) private _ownedTokensIndex;

    function totalSupply() public override view returns(uint256){
      return _allTokens.length;
    }

    function tokenByIndex(uint256 _index) external override view returns(uint256){
      // make sure that the index is not out of bounds of the totalSupply
      require(_index < totalSupply(),"global index is out of bounds!");
      return _allTokens[_index];
    }

    function tokenOfOwnerByIndex(address _owner, uint256 _index) external override view returns(uint256){
       require(_index < balanceOf(_owner),"owner index is out of bounds!");
        return _ownedTokens[_owner][_index];
    }
    function _mint(address to,uint256 tokenId) internal override(ERC721) {
      super._mint(to,tokenId);
      // add tokens to totalsupply-to allTokens
      _addTokensToAllTokensEnumeration(tokenId);
      // add tokens to owner
      _addTokensToOwnerEnumeration(to,tokenId);
      }

      // add tokens _allTokens array and set the position of token index
    function _addTokensToAllTokensEnumeration(uint256 tokenId) private{
      _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }


    function _addTokensToOwnerEnumeration(address to , uint256 tokenId) private{
      //1. set the tokenId to index of that token for a address in _ownedTokens array 
      _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
     //2.add address and token id in _ownedTokens
     _ownedTokens[to].push(tokenId);
    }
}