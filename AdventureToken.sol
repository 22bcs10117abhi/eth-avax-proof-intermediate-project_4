// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract AdventureToken is ERC20, Ownable, ERC20Burnable {
    constructor() ERC20("Adventure Token", "ADVT") Ownable(msg.sender) {}

    enum Items { Sword, Shield, Elixir, Scroll }

    struct Staker {
        uint256 stakedAmount;
        uint256 stakingTime;
    }

    mapping(address => Staker) public stakers;

    struct PlayerInventory {
        uint256 swords;
        uint256 shields;
        uint256 elixirs;
        uint256 scrolls;
    }

    mapping(address => PlayerInventory) public playerInventory;

    uint256 public rewardRate = 1000; // Reward rate per second

    function stakeTokens(uint256 _amount) public {
        require(_amount <= balanceOf(msg.sender), "Insufficient balance to stake");
        _burn(msg.sender, _amount);
        stakers[msg.sender].stakedAmount += _amount;
        stakers[msg.sender].stakingTime = block.timestamp;
    }

    function withdrawStakedTokens() public {
        uint256 stakedAmount = stakers[msg.sender].stakedAmount;
        require(stakedAmount > 0, "No staked tokens to withdraw");

        uint256 stakingDuration = block.timestamp - stakers[msg.sender].stakingTime;
        uint256 reward = stakingDuration * rewardRate;

        stakers[msg.sender].stakedAmount = 0;
        _mint(msg.sender, stakedAmount + reward);
    }

    function redeemItem(Items _item) public {
        if (_item == Items.Sword) {
            require(balanceOf(msg.sender) >= 15, "Insufficient tokens");
            playerInventory[msg.sender].swords += 1;
            burn(15);
        } else if (_item == Items.Shield) {
            require(balanceOf(msg.sender) >= 25, "Insufficient tokens");
            playerInventory[msg.sender].shields += 1;
            burn(25);
        } else if (_item == Items.Elixir) {
            require(balanceOf(msg.sender) >= 8, "Insufficient tokens");
            playerInventory[msg.sender].elixirs += 1;
            burn(8);
        } else if (_item == Items.Scroll) {
            require(balanceOf(msg.sender) >= 5, "Insufficient tokens");
            playerInventory[msg.sender].scrolls += 1;
            burn(5);
        } else {
            revert("Invalid item selected");
        }
    }

    function mintToken(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }

    function checkBalance() public view returns (uint256) {
        return balanceOf(msg.sender);
    }
}
