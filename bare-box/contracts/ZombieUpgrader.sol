pragma solidity ^0.4.22;

import "./ZombieHelper.sol";

contract ZombieUpgrader is ZombieHelper {
    //可以通过冒险或喂养对zoombie进行升级
    
    function adventure(uint _zombieId) external {
        // 每次冒险可以加250xp
        uint _nextTimestamp = zombieArray[_zombieId].nextAdventuerTimestamp;
        require(block.timestamp > _nextTimestamp,"too early");
        zombieArray[_zombieId].nextAdventuerTimestamp += Minutes;  // 测试:每分钟可以冒险一次，生产:每天可以冒险一次
        zombieArray[_zombieId].xp += xp_per_day;
    }
    

    function feed(uint _zombieId) external payable{
        // 每次喂养可以加1000xp
        require(msg.value == 0.01 ether);
        uint _nextTimestamp = zombieArray[_zombieId].nextFeedTimestamp;
        require(block.timestamp > _nextTimestamp,"too early");
        zombieArray[_zombieId].nextFeedTimestamp += Minutes;  // 测试:每分钟可以喂养一次，生产:每天可以喂养一次
        zombieArray[_zombieId].xp += 4 * xp_per_day;
    }
    
    function xp_required(uint _current_level) public view returns(uint xp_to_next_level) {
        // 计算下一等级所需要的经验
        xp_to_next_level = (_current_level + 1 ) * xp_per_day;
        return xp_to_next_level;
    }
    
    function level_up(uint _zombieId) external {
        uint xp_to_next_level = xp_required(zombieArray[_zombieId].level);
        require(zombieArray[_zombieId].xp >= xp_to_next_level, "not enough xp");
        zombieArray[_zombieId].xp -= xp_to_next_level;
        zombieArray[_zombieId].level += 1;
    }
    

    
}