pragma solidity ^0.4.22;

import "./ZombieUpgrader.sol";
import "./IERC721.sol";

contract ZombieOwnership is ZombieHelper, IERC721 {
    using SafeMath for uint256;
    
    mapping (uint => address) zombieApprovals;
    
    // 查询余额
    function balanceOf(address owner) external view returns (uint256 balance) {
        return zombieOwnerCount[owner];
    }
    
    // 查询所有者
    function ownerOf(uint256 tokenId) external view returns (address owner){
        return zombieToOwner[tokenId];
    }
    
    modifier zoombieOwnerOf(uint _zoombie_id) {
        require(zombieToOwner[_zoombie_id] == msg.sender);
        _;
    }
    
    // 交易
    function transfer(address to, uint256 tokenId) public {
        address owner = zombieToOwner[tokenId];
        zombieOwnerCount[to] += 1;
        zombieOwnerCount[owner] -= 1;
        zombieToOwner[tokenId] = to;
    }
    
    // 批准
    function approve(address to, uint256 tokenId) external zoombieOwnerOf(tokenId) {
        zombieApprovals[tokenId] = to;
    }
    
    // 接收
    function takeOwnership(uint256 tokenId) external {
        address owner = zombieToOwner[tokenId];
        zombieOwnerCount[msg.sender] = zombieOwnerCount[msg.sender].add(1);
        zombieOwnerCount[owner] = zombieOwnerCount[owner].sub(1);
        zombieToOwner[tokenId] = msg.sender;
    }
    

}