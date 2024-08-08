# MYGAME ERC20
The smart contract MyGame is an ERC20 token contract that allows the owner to mint and burn tokens. It also implements a skin system where users can redeem different skins using their tokens.

#DESCRIPTION

The MyGame smart contract is an ERC20 token implementation with additional game-specific functionalities. It inherits from OpenZeppelin's ERC20 and Ownable contracts, enabling standard token features and ownership management.
Key Features:
1. Token Details:
        >>Name: Degen
        >>Symbol: DGN

2. Minting and Burning:
        >>Minting: Only the contract owner can mint new tokens.
        >>Burning: Users can burn their own tokens.
3. Token Transfer:
        >>Users can transfer tokens to other addresses.

4. Skins Management:
        >>Available Skins: Blue, Green, Red, Purple.
        >>Redeem Skins: Users can redeem skins by burning a specified amount of tokens:
            Blue: 10 tokens
            Green: 20 tokens
            Red: 30 tokens
            Purple: 40 tokens

5. User Skins Tracking:
        >>A mapping tracks the number of each type of skin owned by users.

6. Utility Functions:
        >>Check Available Skins: Returns the list of available skins.
        >>Check User Skins: Returns the skins owned by the caller.
        >>Check Balance: Returns the token balance of the caller

## Getting Started

### Executing program

To run this program, you can use Remix, an online Solidity IDE. To get started, go to the Remix website at https://remix.ethereum.org/.


```js 
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyGame is ERC20, Ownable {

    string[] skins=["blue",
        "green",
        "red",
        "purple"];

    struct UserSkin{
        uint blue;
        uint green;
        uint red;
        uint purple;
    }
    
    mapping (address=>UserSkin) userSkins;
    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {}

        function mintTokens(address to, uint256 amount) public onlyOwner {
            _mint(to, amount);
    }

    function burnTokens(uint _amount)public {
        _burn(msg.sender,_amount);
    }
    function transferTokens(address _to, uint _amount)public {
        transfer(_to, _amount);
    }
    function checkAvailableSkins()public view returns(string[] memory){
        return skins;
    }

    function checkMySkins()public view returns(UserSkin memory){
        return userSkins[msg.sender];
    }
    
    function checkBalance()public view returns (uint){
        return balanceOf(msg.sender);
    }
    function reedemSkins(uint _index)public {
        require(_index<=3,"invalid index");
        if(_index==0){
            require(balanceOf(msg.sender)>=10,"low balance");
            _burn(msg.sender, 10);
            userSkins[msg.sender].blue++;
        } else if(_index==1){
            require(balanceOf(msg.sender)>=20,"low balance");
            _burn(msg.sender, 20);
            userSkins[msg.sender].green++;
        } else if(_index==2){
            require(balanceOf(msg.sender)>=30,"low balance");
            _burn(msg.sender, 30);
            userSkins[msg.sender].red++;
        } else if(_index==3){
            require(balanceOf(msg.sender)>=40,"low balance");
            _burn(msg.sender, 40);
            userSkins[msg.sender].purple++;
        } else {
            revert("wrong input");
        }

        }
    }
```

## Authors

Abhishek Kumar  
[@Abhishek](https://www.linkedin.com/in/abhishek-kumar-75273024b/)


## License

This MyToken is licensed under the MIT License 
