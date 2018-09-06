pragma solidity ^0.4.23;

import "./Ownable.sol";
import "./ArrayUtils.sol";
import "./SafeMath.sol";
import "./StringUtils.sol";

contract RASC_Item is Ownable {

    address private adminAddress;

    using ArrayUtils for string[];

    using StringUtils for string;

    using SafeMath for uint;

    modifier onlyAdmin() {
        require(msg.sender == adminAddress);
        _;
    }

    constructor() public {
        adminAddress = msg.sender;
    }

    function setAdminAddress(address admin) public onlyOwner {
        require(admin != address(0));
        require(admin != adminAddress);
        adminAddress = admin;
    }
    function getAdminAddress() public view onlyOwner returns(address) {
        return adminAddress;
    }
    //events
    event ItemCreated(
        uint itemIndex, 
        string title, 
        string description, 
        string author, 
        address owner, 
        uint price,
        uint size,
        string categories,
        string domainsAndTags,
        uint createdAt
    );

    event CategoryAdded(uint itemIndex, uint categoryIndex, string category);
    event SubcategoryAdded(uint itemIndex, uint categoryIndex, uint subcategoryIndex, string subcategory);
    event CategoriesAndSubcategoriesDeleted(uint itemIndex);
    event ItemWasDeleted(uint itemIndex);
    event ItemPriceUpdated(uint itemIndex, uint price);
    //basic data item
    struct Item {
        string data;
        uint price;
        address seller;
        bool isDeleted;
        bool isPublic;
        // string title;
        // string description;
        // string author;
        // uint rating;
        // string tags;
        // string cats;
    }
    // mapping (uint => string[]) itemsTags;

    Item[] private items;
    
    mapping (uint => string[]) private itemsCategories;
    mapping (uint => mapping(uint => string[])) private itemsSubcategories;

    mapping (address => uint[]) usersItems;


    function createItem(
        string data, 
        string title, 
        string description, 
        uint price, 
        string author, 
        uint size,
        string memory categories,
        string memory domainsAndTags) public returns(uint index) {
        Item memory item = Item(data, price, msg.sender, false, true);//, title, description, author, rating, tags, categories);
        index = items.push(item) - 1;
        usersItems[msg.sender].push(index);
        addItemCategoriesAndSubcategories(index, categories);
        emit ItemCreated(index, title, description, author, msg.sender, price, size, categories, domainsAndTags, now);
    }
    function deleteItem(uint index) public {
        Item memory item = items[index];
        require(item.seller == msg.sender);
        items[index].isDeleted = true;
        emit ItemWasDeleted(index);
    }
    function removeAllCategoriesAndSubcategories(uint itemIndex) public {
        string[] memory categories = itemsCategories[itemIndex];
        for (uint i = 0; i < categories.length; i++) {
            delete itemsSubcategories[itemIndex][i]; 
        }
        delete itemsCategories[itemIndex];
        emit CategoriesAndSubcategoriesDeleted(itemIndex);
    }

    function changeItemPrice(uint itemIndex, uint price) public {
        Item storage item = items[itemIndex];
        require(item.seller == msg.sender);
        item.price = price;
        emit ItemPriceUpdated(itemIndex, price);
    }

    function addCategory(uint itemIndex, string category) public returns(uint index) {
        Item memory item = items[itemIndex];
        require(item.seller == msg.sender);
        require(itemsCategories[itemIndex].contains(category) == false);

        index = itemsCategories[itemIndex].push(category) - 1;
        emit CategoryAdded(itemIndex, index, category);
    }

    function addSubcategory(uint itemIndex, uint categoryIndex, string subcategory) public returns(uint index) {
        Item memory item = items[itemIndex];
        require(item.seller == msg.sender);
        require(itemsCategories[itemIndex].length > categoryIndex);
        require(itemsSubcategories[itemIndex][categoryIndex].contains(subcategory) == false);
        index = itemsSubcategories[itemIndex][categoryIndex].push(subcategory) - 1;
        emit SubcategoryAdded(itemIndex, categoryIndex, index, subcategory);
    }
    //sample :
    //{1:[1,2]; 2:[2], 3:[4,5]}
    //categories = [1,1,2,3,3]
    //subcategories = [1,2,1,4,5]
    //
    function getItemPrice(
        uint itemIndex, 
        uint[] memory categories, 
        uint[] memory subcategories) public view returns(uint) 
        {
        require(subcategories.length == categories.length);
        uint categoriesCount = itemsCategories[itemIndex].length;
        uint[] memory subcategoriesCount = new uint[](categoriesCount);
        uint price = items[itemIndex].price;

        if (categoriesCount == 0) {
            return price;
        }
        for (uint i = 0; i < categories.length; i++) {
            subcategoriesCount[categories[i]]++;
        }
        for (uint j = 0; j < categoriesCount; j++) {
            if (itemsSubcategories[itemIndex][j].length == 0) {
                continue;
            }
            require(subcategoriesCount[j] > 0);
            price = price.mul(subcategoriesCount[j]).div(itemsSubcategories[itemIndex][j].length);
        }
        return price;
    }
    
    // function addItemPurchaseToUser(uint itemIndex, address user, uint[] memory categories, uint[] memory subcategories) internal {
    //     require(categories.length == subcategories.length);
    //     if (usersItemsPurchase[user].contains(itemIndex) == false) {
    //         usersItemsPurchase[user].push(itemIndex);
    //     }
    //     for (uint i = 0; i < categories.length; i++) {
    //         if (purchaseSubcategories[user][itemIndex][categories[i]].contains(subcategories[i]) == false) {
    //             purchaseSubcategories[user][itemIndex][categories[i]].push(subcategories[i]);
    //         }
    //     }
    //     emit AddedItemPurchaseToUser(itemIndex, user, categories, subcategories);
    // }
    
    function getItemsCount() public view returns(uint count) {
        count = items.length;
    }
    // function getItemInfo(uint index) public view returns(
    //     // string memory title,
    //     // string memory description,
    //     // string memory author, 
    //     string memory data,
    //     uint price, 
    //     address seller, 
    //     uint categoriesCount,
    //     // uint rating,
    //     // string memory tags,
    //     uint[] memory subcategoriesCount,
    //     uint[] memory purchasedCategories,
    //     uint[] memory purchasedSubcategories
    //     ) {
    //     require(items.length > index);
    //     Item memory item = items[index];
    //     data = "";
    //     // title = item.title;
    //     // description = item.description;
    //     // author = item.author;
    //     // rating = item.rating;
    //     // tags = item.tags;
    //     price = item.price;
    //     seller = item.seller;
    //     categoriesCount = itemsCategories[index].length;
    //     subcategoriesCount = new uint[](categoriesCount);
    //     for (uint i = 0; i < categoriesCount; i++) {
    //         subcategoriesCount[i] = itemsSubcategories[index][i].length;
    //     }
    //     if (usersItemsPurchase[msg.sender].contains(index) == true) {
    //         data = item.data;
    //         (purchasedSubcategories, purchasedCategories) = getItemPusrchaseSubcategories(msg.sender, index);
    //     }
    // }

    // function getItemPusrchaseSubcategoriesCount(address user, uint index) internal view returns(uint count) {
    //     uint categoriesCount = itemsCategories[index].length;
    //     count = 0;
    //     for (uint i = 0; i < categoriesCount; i++) {
    //         count += purchaseSubcategories[user][index][i].length;
    //     }
    // }

    // function getItemPusrchaseSubcategories(
    //     address user, 
    //     uint index) 
    //     internal view returns(
    //         uint[] memory subcategories, 
    //         uint[] memory categories) {
    //     uint categoriesCount = itemsCategories[index].length;
    //     uint count = getItemPusrchaseSubcategoriesCount(user, index);
    //     subcategories = new uint[](count);
    //     categories = new uint[](count);
    //     uint key = 0;
    //     for (uint i = 0; i < categoriesCount; i++) {
    //         uint subCount = purchaseSubcategories[user][index][i].length;
    //         for (uint j = 0; j < subCount; j++) {
    //             subcategories[key] = purchaseSubcategories[user][index][i][j];
    //             categories[key] = i;
    //             key++;
    //         }
    //     }
    // }

    function getItemCategoriesCount(uint index) public view returns(uint count) {
        count = itemsCategories[index].length;
    }

    function getItemCategory(uint index, uint categoryIndex) public view returns(string memory category) {
        category = itemsCategories[index][categoryIndex];
    }

    function getItemSubcategoriesCount(uint index, uint categoryIndex) public view returns(uint count) {
        count = itemsSubcategories[index][categoryIndex].length;
    }

    function getItemSubcategory(uint index, uint categoryIndex, uint subcategoryIndex) public view returns(string memory subcategory) {
        subcategory = itemsSubcategories[index][categoryIndex][subcategoryIndex];
    }

    function addItemCategoriesAndSubcategories(uint itemIndex, string memory categoriesAndSubcategories) private {
        string[] memory categories = categoriesAndSubcategories.split(";");
        for (uint i = 0; i < categories.length; i++) {
            string[] memory subcategories = categories[i].split(",");
            if (subcategories.length > 0) {
                if (itemsCategories[itemIndex].contains(subcategories[0]) == false) {
                    uint index = itemsCategories[itemIndex].push(subcategories[0]) - 1;
                    for (uint j = 1; j < subcategories.length; j++) {
                        itemsSubcategories[itemIndex][index].push(subcategories[j]);
                    }
                }
            }
        }
    }
    function getItemObject(uint index) internal view returns (Item memory item) {
        item = items[index];
    }
    function getItemSeller(uint index) public view onlyAdmin returns(address) {
        return items[index].seller;
    }
    function getItemPrice(uint index) public view onlyAdmin returns(uint) {
        return items[index].price;
    }
    function getItemData(uint index) public view onlyAdmin returns(string memory) {
        return items[index].data;
    }
    function getItemIsDeleted(uint index) public view onlyAdmin returns(bool) {
        return items[index].isDeleted;
    }
    function getItemIsPublic(uint index) public view onlyAdmin returns(bool) {
        return items[index].isPublic;
    }
    function getUsersItems(address user) public view onlyAdmin returns(uint[] memory) {
        return usersItems[user];
    }
}