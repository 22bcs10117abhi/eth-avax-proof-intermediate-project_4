# AdventureToken ERC20

Certainly! Here's an introduction to the contract:

---

This Solidity contract, `AdventureToken`, is designed to create an ERC20 token with additional features suitable for a gaming environment. The contract inherits from the OpenZeppelin ERC20, Ownable, and ERC20Burnable contracts, providing it with basic token functionality, ownership control, and burning capabilities.



# Key Feature

1. **Token Staking**:
   - Users can stake their tokens to earn rewards over time. The staked tokens are burned, and rewards are calculated based on the duration of the staking period.
   - **Functions**:
     - `stakeTokens(uint256 _amount)`: Allows users to stake a specified amount of tokens.
     - `withdrawStakedTokens()`: Allows users to withdraw their staked tokens along with the earned rewards.

2. **Item Redemption**:
   - Users can redeem specific in-game items by burning a specified amount of tokens. Each item has a different token requirement.
   - **Function**:
     - `redeemItem(Items _item)`: Allows users to redeem items such as Swords, Shields, Elixirs, and Scrolls by burning the required number of tokens.

3. **Minting Tokens**:
   - The contract owner can mint new tokens to a specified address. This functionality is restricted to the owner to ensure controlled minting.
   - **Function**:
     - `mintToken(address _to, uint256 _amount)`: Allows the owner to mint tokens to a specific address.

4. **Balance Checking**:
   - Users can check their current token balance.
   - **Function**:
     - `getBalance()`: Returns the token balance of the user who called the function.


# Description

Certainly! Here is a detailed description of the contract and its functions:

---

# Contract: AdventureToken

The `AdventureToken` contract is an ERC20 token designed for a gaming environment. It allows users to stake tokens to earn rewards, redeem tokens for in-game items, and provides controlled minting functionality for the contract owner. The contract is built using the OpenZeppelin library for secure and standardized implementations of ERC20, Ownable, and ERC20Burnable functionalities.

# Key Components and Functions

1. **Staking Tokens**:
    - **Function**: `stakeTokens(uint256 _amount)`
        - **Purpose**: Allows a user to stake a specified amount of tokens.
        - **Parameters**: `_amount` - the number of tokens to stake.
        - **Logic**:
            - Checks if the user has enough balance to stake the specified amount.
            - Burns the staked tokens from the user's balance.
            - Updates the user's staked amount and records the staking start time.

2. **Withdrawing Staked Tokens**:
    - **Function**: `withdrawStakedTokens()`
        - **Purpose**: Allows a user to withdraw their staked tokens along with the earned rewards.
        - **Parameters**: None.
        - **Logic**:
            - Retrieves the staked amount for the user.
            - Ensures the user has staked tokens to withdraw.
            - Calculates the duration of the staking period.
            - Computes the reward based on the staking duration and a predefined reward rate.
            - Resets the user's staked amount.
            - Mints the total of the original staked amount plus the reward to the user's balance.

3. **Redeeming Items**:
    - **Function**: `redeemItem(Items _item)`
        - **Purpose**: Allows a user to redeem a specific item by burning a required number of tokens.
        - **Parameters**: `_item` - the item the user wants to redeem.
        - **Logic**:
            - Checks the type of item requested (Sword, Shield, Elixir, or Scroll).
            - Verifies that the user has enough tokens to redeem the specified item.
            - Updates the user's inventory with the redeemed item.
            - Burns the required number of tokens from the user's balance.
            - Reverts the transaction if the item type is invalid.

4. **Minting Tokens**:
    - **Function**: `mintToken(address _to, uint256 _amount)`
        - **Purpose**: Allows the contract owner to mint a specified amount of tokens to a specified address.
        - **Parameters**: `_to` - the address to receive the minted tokens; `_amount` - the number of tokens to mint.
        - **Logic**:
            - Mints the specified amount of tokens to the given address.
            - This function can only be called by the contract owner.

5. **Checking Balance**:
    - **Function**: `checkBalance()`
        - **Purpose**: Allows a user to check their token balance.
        - **Parameters**: None.
        - **Logic**:
            - Returns the balance of tokens held by the caller (the user who invoked the function).

# Implementation Details

- **Staking and Rewards**:
  - Users stake tokens, which are then burned. The staked amount and the staking time are recorded.
  - Upon withdrawal, the reward is calculated based on the staking duration and a predefined reward rate.
  - The total of the original staked amount plus the reward is minted back to the user's balance.

- **Redeeming Items**:
  - Users can redeem various in-game items by burning the corresponding amount of tokens.
  - The contract maintains a record of each user's inventory, updating it as items are redeemed.

- **Ownership and Minting**:
  - The contract owner has the exclusive right to mint new tokens, ensuring that token supply can be managed effectively.

This contract aims to enhance the gaming experience by integrating token staking and item redemption mechanics, encouraging users to engage more deeply with the game while managing their token balances effectively.


```js 
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
```
---
To run this code, first go to https://faucets.chain.link/ and claim free fuji testnet avax faucet using login via github. Now Head towards remixIDE or hardhat as per your intreset, in this project remix was used for its ease. create a new MyContract.sol file and copy the content of AdventureToken.sol into it. In left side go to compile tab and choose the compatible compiler. Then in deploy section choose injection wallet (metamask, phantom, etc.). click Deploy and confirm the transaction.


## Authors

Abhishek Kumar  
[@Abhishek](https://www.linkedin.com/in/abhishek-kumar-75273024b/)


## License

This MyToken is licensed under the MIT License 
