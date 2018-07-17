pragma solidity ^0.4.23;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RASC_ItemsGroup.sol";

contract TestItemsGroups {
    uint public initialBalance = 1 ether;

    function test1() public {
        RASC_ItemsGroup itemsGroup = RASC_ItemsGroup(DeployedAddresses.RASC_ItemsGroup());
        uint index0 = itemsGroup.createItem("item0", 12);
        uint index1 = itemsGroup.createItem("item1", 13);

        
        uint[] memory items = new uint[](2);
        items[0] = index0;
        items[1] = index1;
        uint groupIndex = itemsGroup.createGroup(items, 25);

        Assert.equal(groupIndex, 0, "incorrect groups index");

    }
}