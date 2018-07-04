pragma solidity ^0.4.23;

import "./RASC_Item.sol";
import "./RASC_Access.sol";

contract RASC_ItemsGroup is RASC_Item, RASC_Access {
    //group of items for selling
    struct ItemsGroup {
        uint price;
        address owner;
    }
    ItemsGroup[] itemsGroups;
    mapping(uint => uint[]) groupsItems;
    mapping(uint => BasicAccess[]) groupsAccess;

    function getItemsGroup(uint index) internal view returns(ItemsGroup) {
        return itemsGroups[index];
    }
    function createGroup(uint[] items, uint price) public returns(uint index) {
        
        //TODO: check if all items belong to msg.sender
        
        ItemsGroup memory group = ItemsGroup(price, msg.sender);
        index = itemsGroups.push(group) - 1;
        for (uint i = 0; i < items.length; i++) {
            groupsItems[index].push(items[i]);
        }
        
    }
    function updateGroup(uint index, uint price) public {

    }
    function addGroupAccess() {

    }
    function deleteAccess() {

    }
    function updateAccess() {
        
    }
}