// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts@4.9.0/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.9.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.9.0/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable {

    // Define an event for the redemption
    event Redeemed(address indexed account, string item, uint256 amount);

    // Mapping to store item prices
    mapping(string => uint256) public itemPrices;

    // Mapping to store user's items
    mapping(address => string) public userItems;

    constructor() ERC20("Degen", "DGN") {
        // Set initial item prices
        itemPrices["M14"] = 50;
        itemPrices["AUG"] = 100;
        itemPrices["LMG"] = 50;
        itemPrices["AK"] = 100;
    }

    // Minting new tokens, can only be called by the owner
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Function to burn tokens 
    function burn(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf(msg.sender) >= amount, "Not enough funds");
        _burn(msg.sender, amount);
    }

    // Function to redeem tokens 
    function redeemItem(string memory itemName) public {
        require(itemPrices[itemName] > 0, "Invalid item");
        require(balanceOf(msg.sender) >= itemPrices[itemName], "Not enough funds");
        _burn(msg.sender, itemPrices[itemName]);
        userItems[msg.sender] = itemName;
        emit Redeemed(msg.sender, itemName, itemPrices[itemName]);
    }

    // Function to transfer tokens 
    function transferCoin(address receiver, uint256 amount) external {
        require(receiver != address(0), "Invalid address");
        require(balanceOf(msg.sender) >= amount, "Not enough funds");
        _transfer(msg.sender, receiver, amount);
    }

    // Function to set item prices
    function setItemPrice(string memory itemName, uint256 price) public onlyOwner {
        itemPrices[itemName] = price;
    }

    // Function to get the price of itme
    function getItemPrice(string memory itemName) public view returns (uint256) {
        return itemPrices[itemName];
    }

    // Function to get which itekm redemmed by the user
    function getUserItem(address userAddress) public view returns (string memory) {
        return userItems[userAddress];
    }

    // Function to check if item is redemmed by player
    function isItemRedeemed(address userAddress, string memory itemName) public view returns (bool) {
        return keccak256(abi.encodePacked(userItems[userAddress])) == keccak256(abi.encodePacked(itemName));
    }
}
