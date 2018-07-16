pragma solidity ^0.4.23;

contract RASC_Item {
    //events
    event ItemCreated(uint itemIndex);

    //basic data item
    struct Item {
        string data;
        uint price;
    }
    Item[] items;

    mapping (uint => address[]) itemsOwners;

    mapping (address => mapping(uint => bool)) usersItems;
    mapping (uint => address[]) itemsBuyers;

    function createItem(string data, uint price) public returns(uint index) {
        Item memory item = Item(data, price);
        index = items.push(item) - 1;
        itemsOwners[index].push(msg.sender);

        emit ItemCreated(index);
    }
    
    function getItemInfo(uint index) public view returns(string memory data, uint price, bool isOwner) {
        Item memory item = items[index];
        if (checkUserHasAccessToItemData(index, msg.sender) == true) {
            price = item.price;
            data = item.data;
            isOwner = false;
        } else if (checkUserIsItemOwner(index, msg.sender) == true) {
            price = item.price;
            data = item.data;
            isOwner = true;
        } else {
            price = item.price;
            data = "";
            isOwner = false;
        }
    }
    function checkUserIsItemOwner(uint itemIndex, address user) public view returns(bool) {
        address[] memory owners = itemsOwners[itemIndex];
        for (uint i = 0; i < owners.length; i++) {
            if (owners[i] == user) {
                return true;
            }
        }
        return false;
    }
    function checkUserHasAccessToItemData(uint itemIndex, address user) internal view returns(bool) {
        return usersItems[user][itemIndex];
    }

    function giveAccessToItemData(uint itemIndex, address user) internal {
        usersItems[user][itemIndex] = true;
        itemsBuyers[itemIndex].push(user);
    }
}