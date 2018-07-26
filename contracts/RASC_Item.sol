pragma solidity ^0.4.23;

// import "./RASC_Access.sol";
import "./ArrayUtils.sol";
import "./SafeMath.sol";

contract RASC_Item {
    using ArrayUtils for uint[];
    using ArrayUtils for address[];
    using ArrayUtils for string[];

    using SafeMath for uint;
    //events
    event ItemCreated(uint itemIndex);

    //basic data item
    struct Item {
        string data;
        uint price;
        address seller;
    }
    
    Item[] items;
    
    mapping (uint => string[]) itemsCategories;
    mapping (uint => mapping(uint => string[])) itemsSubcategories;

    mapping (address => uint[]) usersItems;

    mapping (address => uint[]) usersItemsAccess;
    mapping (address => mapping (uint => mapping(uint => uint[]))) accessSubcategories;

    function createItem(string data, uint price) public returns(uint index) {
        Item memory item = Item(data, price, msg.sender);
        index = items.push(item) - 1;
        usersItems[msg.sender].push(index);

        emit ItemCreated(index);
    }

    function removeAllGroups(uint itemIndex) public {
        string[] memory categories = itemsCategories[itemIndex];
        for (uint i = 0; i < categories.length; i++) {
            delete itemsSubcategories[itemIndex][i]; 
        }
        delete itemsCategories[itemIndex];
    }

    function addCategory(uint itemIndex, string category) public returns(uint index) {
        Item memory item = items[itemIndex];
        require(item.seller == msg.sender);
        require(itemsCategories[itemIndex].contains(category) == false);

        index = itemsCategories[itemIndex].push(category) - 1;
    }

    function addSubcategory(uint itemIndex, uint categoryIndex, string subcategory) public returns(uint index) {
        Item memory item = items[itemIndex];
        require(item.seller == msg.sender);
        require(itemsCategories[itemIndex].length > categoryIndex);
        require(itemsSubcategories[itemIndex][categoryIndex].contains(subcategory) == false);
        index = itemsSubcategories[itemIndex][categoryIndex].push(subcategory) - 1;
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

        for (uint i = 0; i < categories.length; i++) {
            subcategoriesCount[categories[i]]++;
        }
        uint price = items[itemIndex].price;
        for (uint j = 0; j < categoriesCount; j++) {
            if (subcategoriesCount[j] > 0) {
                price = price.mul(subcategoriesCount[j]).div(itemsSubcategories[itemIndex][j].length);
            }
        }
        return price;
    }
    
    function addItemAccessToUser(uint itemIndex, address user, uint[] memory categories, uint[] memory subcategories) internal {
        require(categories.length == subcategories.length);
        if (usersItemsAccess[user].contains(itemIndex) == false) {
            usersItemsAccess[user].push(itemIndex);
        }
        for (uint i = 0; i < categories.length; i++) {
            if (accessSubcategories[user][itemIndex][categories[i]].contains(subcategories[i]) == false) {
                accessSubcategories[user][itemIndex][categories[i]].push(subcategories[i]);
            }
        }
    }

    function getItemsCount() public view returns(uint count) {
        count = items.length;
    }

    function getItem(uint index) public view returns(string memory data, uint price, address seller) {
        require(items.length > index);
        Item memory item = items[index];
        data = "";
        price = item.price;
        seller = item.seller;

        if (usersItemsAccess[msg.sender].contains(index) == true) {
            data = item.data;
        }
    }

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
    // mapping (address => mapping(uint => bool)) usersItems;
    // mapping (uint => address[]) itemsBuyers;

    // function createItem(string data, uint price) public returns(uint index) {
    //     Item memory item = Item(data, price);
    //     index = items.push(item) - 1;
    //     itemsOwners[index].push(msg.sender);

    //     emit ItemCreated(index);
    // }
    
    
    // function getItemInfo(uint index) public view returns(string memory data, uint price, bool isOwner) {
    //     Item memory item = items[index];
    //     if (checkUserHasAccessToItemData(index, msg.sender) == true) {
    //         price = item.price;
    //         data = item.data;
    //         isOwner = false;
    //     } else if (checkUserIsItemOwner(index, msg.sender) == true) {
    //         price = item.price;
    //         data = item.data;
    //         isOwner = true;
    //     } else {
    //         price = item.price;
    //         data = "";
    //         isOwner = false;
    //     }
    // }
    // function checkUserIsItemOwner(uint itemIndex, address user) public view returns(bool) {
    //     address[] memory owners = itemsOwners[itemIndex];
    //     return owners.contains(user);
    // }
    // function checkUserHasAccessToItemData(uint itemIndex, address user) internal view returns(bool) {
    //     return usersItems[user][itemIndex];
    // }

    // function giveAccessToItemData(uint itemIndex, address user) internal {
    //     usersItems[user][itemIndex] = true;
    //     itemsBuyers[itemIndex].push(user);
    // }
}