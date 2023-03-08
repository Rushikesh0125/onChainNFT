// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract onChainGameChar is ERC721URIStorage {

    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private tokenId; 

    mapping (uint256 => uint256) tokenIdToLevels;

    constructor() ERC721("onChainGameChar","OCGC"){
        
    }

    function getLevel(uint _tokenId) public view returns (string memory) {
        return tokenIdToLevels[_tokenId].toString();
    }

    function generateCharacter(uint256 _tokenId) public view returns(string memory){

        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevel(_tokenId),'</text>',
            '</svg>'
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            )    
        );
    }

    function getTokenURI(uint256 _tokenId) public view returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "Chain Battles #', _tokenId.toString(), '",',
                '"description": "Battles on chain",',
                '"image": "', generateCharacter(_tokenId), '"',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function mint() public {
        tokenId.increment();
        uint256 newTokenId = tokenId.current();
        _safeMint( msg.sender , newTokenId);
        tokenIdToLevels[newTokenId] = 0;
        _setTokenURI(newTokenId, getTokenURI(newTokenId));
    }

    function train(uint256 _tokenId) public{
        require(_exists(_tokenId), "you are trying to access non existing character");
        require(ownerOf(_tokenId) == msg.sender, "only owner of character can train the character");
        uint256 currentLevel = tokenIdToLevels[_tokenId];
        tokenIdToLevels[_tokenId] = currentLevel+1;
        _setTokenURI(_tokenId, getTokenURI(_tokenId));
    }
}
