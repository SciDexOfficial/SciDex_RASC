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

    modifier onlyGroupOwner(uint groupIndex) {
        ItemsGroup memory group = itemsGroups[groupIndex];
        require(group.owner == msg.sender);
        _;
    } 

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
    function updateGroup(uint index, uint price) public onlyGroupOwner(index) {
        ItemsGroup storage group = itemsGroups[index];
        group.price = price;
    }
    function addGroupAccess(uint groupIndex, uint fieldType, uint minValue, uint maxValue, uint multiplier) public onlyGroupOwner(groupIndex) {
        BasicAccess memory access = BasicAccess(fieldType, minValue, maxValue, multiplier);
        groupsAccess[groupIndex].push(access);
    }
    function deleteAccess(uint groupIndex) public onlyGroupOwner(groupIndex) {
        //remove all access objects
    }
    function updateAccess(uint groupIndex, uint accessIndex, uint fieldType, uint minValue, uint maxValue, uint multiplier) public onlyGroupOwner(groupIndex) {
        BasicAccess storage access = groupsAccess[groupIndex][accessIndex];
        access.userFieldType = fieldType;
        access.minValue = minValue;
        access.maxValue = maxValue;
        access.multiplier = multiplier;
    }
    function getGroupAccessCount(uint index) public view onlyGroupOwner(index) returns(uint) {
        return groupsAccess[index].length;
    }

    function getGroupAccess(uint groupIndex, uint accessIndex) public view onlyGroupOwner(groupIndex) returns(uint, uint, uint , uint) {
        BasicAccess memory access = groupsAccess[groupIndex][accessIndex];
        return (access.userFieldType, access.minValue, access.maxValue, access.multiplier);
    }
}