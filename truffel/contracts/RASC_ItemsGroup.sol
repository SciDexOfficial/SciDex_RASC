pragma solidity ^0.4.23;

import "./RASC_Item.sol";
import "./RASC_Access.sol";

contract RASC_ItemsGroup is RASC_Item, RASC_Access {
    //group of items for selling
    struct ItemsGroup {
        uint[] itemsIndexies;
        uint price;
        BasicAccess[] access;
    }
    ItemsGroup[] itemsGroups;
}