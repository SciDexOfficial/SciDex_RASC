pragma solidity ^0.4.23;

import "./SafeMath.sol";
import "./RASC_User.sol";
import "./RASC_Transaction.sol"; 

contract RASC_Store is RASC_Transaction, RASC_User {
    using SafeMath for uint;

    //return all items availabel for sender
    function getItemsGroupIds() public view returns(uint[] memory ids) {
        uint groupsCount = itemsGroups.length;
        ids = new uint[](groupsCount);
        uint groupsFilteringCount = 0;
        uint userIndex = getUserIndex(msg.sender);
        for (uint i = 0; i < groupsCount; i++) {
            ItemsGroup memory group = itemsGroups[i];

            if (hasAccess(userIndex, group) == true){
                ids[groupsFilteringCount] = i;
                groupsFilteringCount++;
            }
        }
    }
    //check if user has access to itemsGroup
    function hasAccess(uint userIndex, ItemsGroup memory group) internal view returns(bool) {
        uint accessCount = group.access.length;
        for (uint i = 0; i < accessCount; i++){
            if (checkUserAccess(userIndex, group.access[i]) == false){
                return false;
            }
        }
        return true;
    }
    //
    function checkUserAccess(uint userIndex, BasicAccess memory access) internal view returns(bool) {
        uint value = getValueForAccessType(userIndex, access.accessType).mul(access.multiplier);
        return ((value >= access.minValue) && (value <= access.maxValue));
        
    }    
}