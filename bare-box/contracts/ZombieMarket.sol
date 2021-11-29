pragma solidity ^0.4.22;

import './safemath.sol';
import "./ZombieOwnership.sol";

contract ZombieMarket is ZombieOwnership{
    
    using SafeMath for uint;
    
    // 最低价
    uint public lowest_price = 0.1 ether;
    
    // 僵尸商品
    struct zombieGoods{
        uint zoombie_id;
        uint sell_price;
        address seller;
        uint index;
    }
    
    uint[] public zombieGoodsArray;
    // zoombie_id => bool
    mapping (uint => zombieGoods) public zombieGoodsDict;
    // zoombie_id => zombieGoodsArray index
    
    function sell(uint _zoombie_id, uint _sell_price) external zoombieOwnerOf(_zoombie_id) {
        require(_sell_price >= lowest_price, "must more than lowest price"); // 卖价高于最低价
        require(zombieGoodsDict[_zoombie_id].zoombie_id == 0, "already on sale"); 
        address owner = zombieToOwner[_zoombie_id];
        zombieGoodsArray.push(_zoombie_id);
        uint index = zombieGoodsArray.length-1;
        
        zombieGoods memory goods = zombieGoods(_zoombie_id, _sell_price, owner, index);
        zombieGoodsDict[_zoombie_id] = goods;
    }
    
    function buy(uint _zoombie_id) external payable {
        zombieGoods zombie_good = zombieGoodsDict[_zoombie_id];
        require(msg.value >= zombie_good.sell_price, "must more than sell price"); 
        zombie_good.seller.transfer(msg.value); // 
        transfer(msg.sender, _zoombie_id);
        
        uint index = zombieGoodsDict[_zoombie_id].index;
        if (zombieGoodsArray.length > 1) {
             zombieGoodsArray[index] = zombieGoodsArray[zombieGoodsArray.length-1];
            }
        zombieGoodsArray.length--;
        
        delete zombieGoodsDict[_zoombie_id];
        
    }
    
    
    function getzombieGoodsArray() external view returns (uint[]) {
        return zombieGoodsArray;
    }
    
}