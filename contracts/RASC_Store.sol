pragma solidity ^0.4.23;

import "./SafeMath.sol";
import "./RASC_User.sol";
import "./RASC_Transaction.sol"; 

contract RASC_Store is RASC_Transaction {
    using SafeMath for uint;
    using ArrayUtils for uint[];
    
    address userContractAddress;
    
    event ItemBought(uint itemIndex, uint transactionIndex, uint[] categories, uint[] subcategories);

    function setUserContract(address contractAddress) public onlyOwner {
        userContractAddress = contractAddress;
    }

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
    //store's items info 

    function getItemInfo(uint index) public view returns(
        // string memory title,
        // string memory description,
        // string memory author, 
        string memory data,
        uint price, 
        address seller, 
        uint categoriesCount,
        // uint rating,
        // string memory tags,
        uint[] memory subcategoriesCount,
        uint[] memory purchasedCategories,
        uint[] memory purchasedSubcategories
        ) {
        Item memory item = getItemObject(index);
        data = "";
        // title = item.title;
        // description = item.description;
        // author = item.author;
        // rating = item.rating;
        // tags = item.tags;
        price = item.price;
        seller = item.seller;
        categoriesCount = getItemCategoriesCount(index);//itemsCategories[index].length;
        subcategoriesCount = new uint[](categoriesCount);
        for (uint i = 0; i < categoriesCount; i++) {
            subcategoriesCount[i] = getItemSubcategoriesCount(index, i);//itemsSubcategories[index][i].length;
        }
        if (usersItemsPurchase[msg.sender].contains(index) == true) {
            data = item.data;
            (purchasedSubcategories, purchasedCategories) = getItemPusrchaseSubcategories(msg.sender, index);
        }
    }

    function getItemPusrchaseSubcategoriesCount(address user, uint index) internal view returns(uint count) {
        uint categoriesCount = getItemCategoriesCount(index);//itemsCategories[index].length;
        count = 0;
        for (uint i = 0; i < categoriesCount; i++) {
            count += purchaseSubcategories[user][index][i].length;
        }
    }

    function getItemPusrchaseSubcategories(
        address user, 
        uint index) 
        internal view returns(
            uint[] memory subcategories, 
            uint[] memory categories) {
        uint categoriesCount = getItemCategoriesCount(index);//itemsCategories[index].length;
        uint count = getItemPusrchaseSubcategoriesCount(user, index);
        subcategories = new uint[](count);
        categories = new uint[](count);
        uint key = 0;
        for (uint i = 0; i < categoriesCount; i++) {
            uint subCount = purchaseSubcategories[user][index][i].length;
            for (uint j = 0; j < subCount; j++) {
                subcategories[key] = purchaseSubcategories[user][index][i][j];
                categories[key] = i;
                key++;
            }
        }
    }
}