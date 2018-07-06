pragma solidity ^0.4.23;

contract RASC_Item {
    //events
    ItemCreated(uint itemIndex);

    //basic data item
    struct Item {
        string data;
        uint price;
    }
    Item[] items;
    
    mapping (uint => address[]) itemsOwners;

    function createItem(string data, uint price) public returns(uint index) {
        Item memory item = Item(data, price);
        index = items.push(item) - 1;
        itemsOwners[index].push(msg.sender);

        emit ItemCreated(index);
    }
}