// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract AdventureToken is ERC20, Ownable, ERC20Burnable {
    constructor() ERC20("Adventure Token", "ADVT") Ownable(msg.sender) {}

    enum GameItems { Sword, Shield, Elixir, Scroll }

    struct StakeDetails {
        uint256 amountStaked;
        uint256 stakeStartTime;
    }

    mapping(address => StakeDetails) public stakingRecords;

    struct PlayerInventory {
        uint256 swords;
        uint256 shields;
        uint256 elixirs;
        uint256 scrolls;
    }

    mapping(address => PlayerInventory) public playerInventories;

    uint256 public rewardPerSecond = 1000; // Reward rate per second

    function stakeAdventureTokens(uint256 _amount) public {
        require(_amount <= balanceOf(msg.sender), "Insufficient balance to stake");
        _burn(msg.sender, _amount);
        stakingRecords[msg.sender].amountStaked += _amount;
        stakingRecords[msg.sender].stakeStartTime = block.timestamp;
    }

    function withdrawStakedAdventureTokens() public {
        uint256 stakedAmount = stakingRecords[msg.sender].amountStaked;
        require(stakedAmount > 0, "No staked tokens to withdraw");

        uint256 stakingDuration = block.timestamp - stakingRecords[msg.sender].stakeStartTime;
        uint256 reward = stakingDuration * rewardPerSecond;

        stakingRecords[msg.sender].amountStaked = 0;
        _mint(msg.sender, stakedAmount + reward);
    }

    function redeemGameItem(GameItems _item) public {
        if (_item == GameItems.Sword) {
            require(balanceOf(msg.sender) >= 15, "Insufficient tokens for Sword");
            playerInventories[msg.sender].swords += 1;
            burn(15);
        } else if (_item == GameItems.Shield) {
            require(balanceOf(msg.sender) >= 25, "Insufficient tokens for Shield");
            playerInventories[msg.sender].shields += 1;
            burn(25);
        } else if (_item == GameItems.Elixir) {
            require(balanceOf(msg.sender) >= 8, "Insufficient tokens for Elixir");
            playerInventories[msg.sender].elixirs += 1;
            burn(8);
        } else if (_item == GameItems.Scroll) {
            require(balanceOf(msg.sender) >= 5, "Insufficient tokens for Scroll");
            playerInventories[msg.sender].scrolls += 1;
            burn(5);
        } else {
            revert("Invalid item selected");
        }
    }

    function mintAdventureToken(address _recipient, uint256 _amount) public onlyOwner {
        _mint(_recipient, _amount);
    }

    function getBalance() public view returns (uint256) {
        return balanceOf(msg.sender);
    }
}
