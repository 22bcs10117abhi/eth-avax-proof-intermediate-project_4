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
