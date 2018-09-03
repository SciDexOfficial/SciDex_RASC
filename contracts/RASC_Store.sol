pragma solidity ^0.4.23;

import "./SafeMath.sol";
import "./RASC_User.sol";
import "./RASC_Transaction.sol"; 

contract RASC_Store is RASC_Transaction, RASC_User {
    using SafeMath for uint;
    using ArrayUtils for uint[];

    event ItemBought(uint itemIndex, uint transactionIndex, uint[] categories, uint[] subcategories);

    function buyItem(uint itemIndex, uint[] memory categories, uint[] memory subcategories) payable public {
        require(canBuyCategoriesAndSubcategories(itemIndex, msg.sender, categories, subcategories));
        //create transaction
        uint price = getItemPrice(itemIndex, categories, subcategories);
        // require(msg.value >= price);
        
        uint transactionIndex = createTransaction(
            msg.sender, 
            address(0), 
            itemIndex, 
            TransactionStatus.created, 
            price, 
            categories, 
            subcategories
            );
        payTransaction(transactionIndex);
        autoconfirmTransaction(transactionIndex, categories, subcategories);
        emit ItemBought(itemIndex, transactionIndex, categories, subcategories);
    }

    function getStoreItems(uint from, uint count) public view returns(
        uint nextPageIndex, 
        uint[] memory indexies, 
        address[] memory sellers, 
        uint[] memory prices) 
        {
        require(count > 0);
        uint itemsCount = getItemsCount();
        require(from < itemsCount);
        uint to = from + count;
        uint correctCount = count;
    
        if (to > itemsCount) {
            to = itemsCount;
            correctCount = to - from;
        }
        indexies = new uint[](correctCount);
        prices = new uint[](correctCount);
        sellers = new address[](correctCount);
        uint i = 0;
        uint index = from;
        while (i < to - from) {
            Item memory item = getItemObject(index);//items[index];
            if (item.isDeleted == true) {
                index++;
                continue;
            }
            if (item.isPublic == false) {
                //TODO: check if user has access to item
                prices[i] = item.price;
                sellers[i] = item.seller;
                indexies[i] = index;
                index++;
                i++;
            } else {
                prices[i] = item.price;
                sellers[i] = item.seller;
                indexies[i] = index;
                index++;
                i++;
            }
            
        }

        nextPageIndex = index;
    }

    function getBoughtItems() public view returns(uint[] memory result) {
        result = usersItemsPurchase[msg.sender];
    }

    function getCreatedItems() public view returns(uint[] memory result) {
        result = usersItems[msg.sender];
    }

    function canBuyCategoriesAndSubcategories(
        uint itemIndex, 
        address user, 
        uint[] memory categories, 
        uint[] memory subcategories) private view returns(bool) {
        for (uint i = 0; i < subcategories.length; i++) {
            uint[] memory subcat = purchaseSubcategories[user][itemIndex][categories[i]];
            if (subcat.contains(subcategories[i]) == false) {
                return true;
            }
        }
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