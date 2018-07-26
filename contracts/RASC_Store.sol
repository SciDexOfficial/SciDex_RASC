pragma solidity ^0.4.23;

import "./SafeMath.sol";
import "./RASC_User.sol";
import "./RASC_Transaction.sol"; 

contract RASC_Store is RASC_Transaction, RASC_User {
    using SafeMath for uint;

    
    function buyItem(uint itemIndex, uint[] memory categories, uint[] memory subcategories) payable public {
        //create transaction
        uint price = getItemPrice(itemIndex, categories, subcategories);
        require(msg.value >= price);
        createTransaction(msg.sender, address(0), itemIndex, TransactionStatus.confirmed, categories, subcategories);
        addItemAccessToUser(itemIndex, msg.sender, categories, subcategories);
    }

    function getStoreItems(uint from, uint count) public view returns(uint nextPageIndex, address[] memory sellers, uint[] memory prices) {
        require(count > 0);
        require(from < items.length);
        uint to = from + count;
        uint currentCount = count;

        if (to > items.length) {
            to = items.length;
            currentCount = to - from;
        }

        prices = new uint[](currentCount);
        sellers = new address[](currentCount);
        
        for (uint i = from; i < to; i++) {
            Item memory item = items[i];
            prices[i] = item.price;
            sellers[i] = item.seller;
        }

        nextPageIndex = to;
    }
    //return all items availabel for sender
    // function getItemsGroupIds() public view returns(uint[] memory indexes) {
    //     uint groupsCount = itemsGroups.length;
    //     indexes = new uint[](groupsCount);
    //     uint groupsFilteringCount = 0;
    //     uint userIndex = getUserIndex(msg.sender);
    //     for (uint i = 0; i < groupsCount; i++) {
    //         if (hasAccess(userIndex, i) == true){
    //             indexes[groupsFilteringCount] = i;
    //             groupsFilteringCount++;
    //         }
    //     }
    // }
    //check if user has access to itemsGroup
    // function hasAccess(uint userIndex, uint groupIndex) internal view returns(bool) {
    //     uint accessCount = groupsAccess[groupIndex].length;
    //     if (accessCount == 0) {
    //         return true;
    //     } 
    //     for (uint i = 0; i < accessCount; i++){
    //         if (checkUserAccess(userIndex, groupsAccess[groupIndex][i]) == false) {
    //             return false;
    //         }
    //     }
    //     return true;
    // }
    //
    // function checkUserAccess(uint userIndex, BasicAccess memory access) internal view returns(bool) {
    //     uint value = getValueForAccessType(userIndex, access.userFieldType).mul(access.multiplier);
    //     return ((value >= access.minValue) && (value <= access.maxValue));
        
    // }  

    //
    // function buyItemGroup(uint groupIndex) public payable {
    //     ItemsGroup memory group = itemsGroups[groupIndex];
    //     //check if user can buy this group
    //     require(group.price <= msg.value, "Incorrect 'value'");

    //     for (uint i = 0; i < groupsItems[groupIndex].length; i++) {
    //         giveAccessToItemData(groupsItems[groupIndex][i], msg.sender);
    //     }
    //     uint rest = msg.value - group.price;
    //     if (rest > 0) {
    //         msg.sender.transfer(rest);
    //     }
        
    // }  
    //
    // function checkMyAccessToItemData(uint index) public view returns(bool) {
    //     return checkUserHasAccessToItemData(index, msg.sender);
    // }
    // function getCreatedItems() public view returns(uint[] memory result) {
    //     uint[] memory tempData = new uint[](items.length);
    //     uint count = 0;
    //     for (uint i = 0; i < items.length; i++) {
    //         for (uint j = 0; j < itemsOwners[i].length; j++) {
    //             if (itemsOwners[i][j] == msg.sender) {
    //                 tempData[count] = i;
    //                 count++;
    //             } 
    //         }
    //     }
    //     result = new uint[](count);
    //     for (uint ii = 0; ii < count; ii++) {
    //         result[ii] = tempData[ii];
    //     }
    // }

    // function getBoughtItems() public view returns(uint[] memory result) {
    //     uint[] memory tempData = new uint[](items.length);
    //     uint count = 0;
    //     for (uint i = 0; i < items.length; i++) {
    //         if (checkUserHasAccessToItemData(i, msg.sender)) {
    //             tempData[count] = i;
    //             count++;
    //         } 
    //     }
    //     result = new uint[](count);
    //     for (uint ii = 0; ii < count; ii++) {
    //         result[ii] = tempData[ii];
    //     }
    // }
}