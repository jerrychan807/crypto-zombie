pragma solidity ^0.4.22;

import "./ZombieFactory.sol";

contract ZombieHelper is ZombieFactory {
    
    function getZombieCount(address owner) public view returns (uint) {
        return zombieOwnerCount[owner];
    }
    
    function getAllZombie(address owner) public view returns (uint[]){
        uint zombieOwnerCount = getZombieCount(owner);
        uint[] memory ZombieIdArray = new uint[](zombieOwnerCount);
        uint index = 0;
        for (uint i=0; i < zombieArray.length ; i++){
            if (zombieToOwner[zombieArray[i].id] == owner) {
                ZombieIdArray[index] = zombieArray[i].id;
                index += 1;
            }
        }
        return ZombieIdArray;
    }
}
