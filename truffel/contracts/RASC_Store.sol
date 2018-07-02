pragma solidity ^0.4.23;

import "./SafeMath.sol";
import "./RASC_User.sol";
import "./RASC_Transaction.sol"; 

contract RASC_Store is RASC_Transaction, RASC_User {
    using SafeMath for uint;
    // mapping(uint => uint) itemsHolders;
    function getItemsGroupIds() public view returns(uint[] memory ids) {
        uint groupsCount = itemsGroups.length;
        ids = new uint[](groupsCount);
        uint groupsFilteringCount = 0;
        User memory user = getUser(msg.sender);
        for (uint i = 0; i < groupsCount; i++) {
            ItemsGroup memory group = itemsGroups[i];

            if (hasAccess(user, group) == true){
                ids[groupsFilteringCount] = i;
                groupsFilteringCount++;
            }
        }
    }
    function hasAccess(User memory user, ItemsGroup memory group) internal pure returns(bool) {
        uint accessCount = group.access.length;
        for (uint i = 0; i < accessCount; i++){
            if (checkUserAccess(user, group.access[i]) == false){
                return false;
            }
        }
        return true;
    }
    function checkUserAccess(User memory user, BasicAccess memory access) internal pure returns(bool) {
        
        uint value = getValueForAccess(user, access.accessType).mul(access.multiplier);
        return ((value >= access.minValue) && (value <= access.maxValue));
        
    }    
}