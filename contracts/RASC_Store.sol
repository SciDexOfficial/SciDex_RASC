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
}