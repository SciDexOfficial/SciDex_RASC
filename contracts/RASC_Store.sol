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
        if (accessCount == 0) {
            return true;
        } 
        for (uint i = 0; i < accessCount; i++){
            if (checkUserAccess(userIndex, groupsAccess[groupIndex][i]) == false) {
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

    //
    function buyItemGroup(uint groupIndex) public payable {
        ItemsGroup memory group = itemsGroups[groupIndex];
        //check if user can buy this group
        require(group.price <= msg.value, "Incorrect 'value'");

        for (uint i = 0; i < groupsItems[groupIndex].length; i++) {
            giveAccessToItemData(groupsItems[groupIndex][i], msg.sender);
        }
        uint rest = msg.value - group.price;
        if (rest > 0) {
            msg.sender.transfer(rest);
        }
        
    }  
    //
    function checkMyAccessToItemData(uint index) public view returns(bool) {
        return checkUserHasAccessToItemData(index, msg.sender);
    }
    function getCreatedItems() public view returns(uint[] memory result) {
        uint[] memory tempData = new uint[](items.length);
        uint count = 0;
        for (uint i = 0; i < items.length; i++) {
            for (uint j = 0; j < itemsOwners[i].length; j++) {
                if (itemsOwners[i][j] == msg.sender) {
                    tempData[count] = i;
                    count++;
                } 
            }
        }
        result = new uint[](count);
        for (uint ii = 0; ii < count; ii++) {
            result[ii] = tempData[ii];
        }
    }

    function getBoughtItems() public view returns(uint[] memory result) {
        uint[] memory tempData = new uint[](items.length);
        uint count = 0;
        for (uint i = 0; i < items.length; i++) {
            if (checkUserHasAccessToItemData(i, msg.sender)) {
                tempData[count] = i;
                count++;
            } 
        }
        result = new uint[](count);
        for (uint ii = 0; ii < count; ii++) {
            result[ii] = tempData[ii];
        }
    }
}