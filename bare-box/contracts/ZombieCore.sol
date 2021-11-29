pragma solidity ^0.4.22;


import "./ZombieMarket.sol";
import "./ZombieUpgrader.sol";

contract ZombieCore is ZombieUpgrader, ZombieMarket {
    
     // 名称
    string public constant name = "JerryCryptoZombie";
    // 符号
    string public constant symbol = "JCZ";

    function() external payable {
    }

    function withdraw() external onlyOwner {
        owner.transfer(address(this).balance);
    }

    function checkBalance() external view onlyOwner returns(uint) {
        return address(this).balance;
    }
}
    