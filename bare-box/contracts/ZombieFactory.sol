pragma solidity ^0.4.22;

import './safemath.sol';
import './ownable.sol';

contract ZombieFactory is Ownable{
    
    using SafeMath for uint;
    
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint constant Day = 1 days;
    uint constant Minutes = 1 minutes;
    uint constant xp_per_day = 250e18;
    
    struct Zombie {
        uint id;
        string name;
        uint dna;
        uint level;
        uint xp;
        uint nextAdventuerTimestamp;
        uint nextFeedTimestamp;
    }
    
    // 地址拥有僵尸数量映射：拥有者 => 僵尸数量
    mapping (address=>uint) public zombieOwnerCount;
    // 僵尸拥有者映射：僵尸ID => 拥有者
    mapping (uint=>address) public zombieToOwner;
    
    // mapping (uint=>Zoombie) public zoombieLib;
    // 所有僵尸集合
    Zombie[] public zombieArray;
    
    event createZombieEvent(string name);
    
    function createZoombie(string name) public {
        // 每个人可以mint两只
        require(zombieOwnerCount[msg.sender] < 2, "only can mint 2 Zoombie");
        zombieOwnerCount[msg.sender] = zombieOwnerCount[msg.sender].add(1);
        
        uint random_dna = generateRandomDna(name);
        uint zombieNum = zombieArray.length;
        Zombie memory new_zombie = Zombie(zombieNum, name, random_dna, 0, 0, block.timestamp, block.timestamp);
        zombieArray.push(new_zombie);
        zombieToOwner[zombieNum] = msg.sender;
        emit createZombieEvent(name);
    }
    
    // 根据名字随机生成16位dna数字
    function generateRandomDna(string name) private returns (uint) {
        return uint(keccak256(abi.encodePacked(name, block.timestamp))) % dnaModulus;
    }
    
    
}