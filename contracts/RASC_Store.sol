pragma solidity ^0.4.23;

import "./SafeMath.sol";
import "./RASC_User.sol";
import "./RASC_Transaction.sol"; 

contract RASC_Store is RASC_Transaction, RASC_User {
    using SafeMath for uint;

    //return all items availabel for sender
    function getItemsGroupIds() public view returns(uint[] memory indexes) {
        uint groupsCount = itemsGroups.length;
        indexes = new uint[](groupsCount);
        uint groupsFilteringCount = 0;
        uint userIndex = getUserIndex(msg.sender);
        for (uint i = 0; i < groupsCount; i++) {

            if (hasAccess(userIndex, i) == true){
                indexes[groupsFilteringCount] = i;
                groupsFilteringCount++;
            }
        }
    }
    //check if user has access to itemsGroup
    function hasAccess(uint userIndex, uint groupIndex) internal view returns(bool) {
        uint accessCount = groupsAccess[groupIndex].length;
        for (uint i = 0; i < accessCount; i++){
            if (checkUserAccess(userIndex, groupsAccess[groupIndex][i]) == false){
                return false;
            }
        }
        return true;
    }
    //
    function checkUserAccess(uint userIndex, BasicAccess memory access) internal view returns(bool) {
        uint value = getValueForAccessType(userIndex, access.userFieldType).mul(access.multiplier);
        return ((value >= access.minValue) && (value <= access.maxValue));
        
    }    
}