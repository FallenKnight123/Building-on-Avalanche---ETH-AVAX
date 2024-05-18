// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    mapping (string => uint256) public SearchItem;
    string[] private itemNames;

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        SearchItem["sword"] = 100;
        SearchItem["shield"] = 150;
        SearchItem["potion"] = 50;
        SearchItem["armor"] = 200;
        SearchItem["ring"] = 250;

        itemNames = ["sword", "shield", "potion", "armor", "ring"];
    }

    function getAllItems() external view returns (string[] memory, uint256[] memory) {
        uint256[] memory values = new uint256[](itemNames.length);
        for (uint256 i = 0; i < itemNames.length; i++) {
            values[i] = SearchItem[itemNames[i]];
        }
        return (itemNames, values);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        require(to != address(0), "Invalid address");
        require(amount > 0, "Amount must be greater than zero");

        _mint(to, amount);
    }

    function redeemTokens(string memory itemName) external {
        require(bytes(itemName).length > 0, "Item name must not be empty");
        string memory lowercaseItemName = _toLower(itemName);
        require(SearchItem[lowercaseItemName] > 0, "Item not in the list");

        uint256 itemValue = SearchItem[lowercaseItemName];
        require(balanceOf(msg.sender) >= itemValue, "Insufficient balance");

        _burn(msg.sender, itemValue);
    }

    function burn(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");

        _burn(msg.sender, amount);
    }

    function _toLower(string memory _str) internal pure returns (string memory) {
        bytes memory strBytes = bytes(_str);
        for (uint i = 0; i < strBytes.length; i++) {
            if ((uint8(strBytes[i]) >= 65) && (uint8(strBytes[i]) <= 90)) {
                strBytes[i] = bytes1(uint8(strBytes[i]) + 32);
            }
        }
        return string(strBytes);
    }
}
