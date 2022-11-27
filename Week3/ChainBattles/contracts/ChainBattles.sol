// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// Deployed at address 0xF5A6E7B581ad86016Bb93Ca56441017345158d50

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct Warrior {
        uint256 level;
        uint256 speed;
        uint256 hp;
        uint256 strength;
        uint256 defense;
    }

    event WarriorTrained(
        uint256 tokenId,
        uint256 level,
        uint256 speed,
        uint256 hp,
        uint256 strength,
        uint256 defense
    );

    mapping(uint256 => Warrior) public tokenIdToWarrior;

    constructor() ERC721("Chain Battles", "CBTLS") {}

    function generateCharacter(uint256 _tokenId)
        public
        view
        returns (string memory)
    {
        Warrior memory warrior = tokenIdToWarrior[_tokenId];
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="30%" class="base" dominant-baseline="middle" text-anchor="middle">Warrior</text>',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Level: ",
            warrior.level.toString(),
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Speed: ",
            warrior.speed.toString(),
            "</text>",
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "HP: ",
            warrior.hp.toString(),
            "</text>",
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Strength: ",
            warrior.strength.toString(),
            "</text>",
            '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Defense: ",
            warrior.defense.toString(),
            "</text>",
            "</svg>"
        );

        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    function getTokenURI(uint256 _tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',
            _tokenId.toString(),
            '",',
            '"description": "Battles on chain",',
            '"image": "',
            generateCharacter(_tokenId),
            '"',
            "}"
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        Warrior memory warrior = Warrior(
            0,
            random(1),
            random(2),
            random(3),
            random(4)
        );
        tokenIdToWarrior[newItemId] = warrior;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 _tokenId) public {
        require(_exists(_tokenId), "Please use an existing Token");
        require(
            msg.sender == ownerOf(_tokenId),
            "You must own this token to train it"
        );
        Warrior memory warrior = tokenIdToWarrior[_tokenId];
        warrior.level++;
        warrior.hp = random(1);
        warrior.defense = random(2);
        warrior.speed = random(3);
        warrior.strength = random(4);
        tokenIdToWarrior[_tokenId] = warrior;
        _setTokenURI(_tokenId, getTokenURI(_tokenId));
        emit WarriorTrained(
            _tokenId,
            warrior.level,
            warrior.speed,
            warrior.hp,
            warrior.strength,
            warrior.defense
        );
    }

    function random(uint256 _seed) private view returns (uint) {
        return
            uint(
                keccak256(
                    abi.encodePacked(block.difficulty, block.timestamp, _seed)
                )
            ) % 101;
    }
}
