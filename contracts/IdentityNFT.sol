// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract IdentityNFT is ERC721Enumerable, Ownable {
    mapping(address => bool) private _exists;

    constructor() ERC721("IdentityNFT", "iNFT") {}

    function mint() public {
        require(!_exists[msg.sender], "IdentityNFT: already exists for this address");
        _exists[msg.sender] = true;
        _safeMint(msg.sender, totalSupply());
    }

    function checkOwnership(address owner) public view returns (bool) {
        return _exists[owner];
    }
}