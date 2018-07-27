pragma solidity ^0.4.23;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RASC_Item.sol";

contract TestItem {
    function test1() public {
        RASC_Item item = RASC_Item(DeployedAddresses.RASC_Item());
        uint index = item.createItem("tttt", 12);
        uint price;
        address seller;
        string memory data;
        (data, price, seller) = item.getItemInfo(index);
        Assert.equal(price, 12, "expected 12");
    }
    function test2() public {
        RASC_Item item = RASC_Item(DeployedAddresses.RASC_Item());
        uint index = item.createItem("aaaa", 1);
        uint price;
        string memory data;
        address seller;
        (data, price, seller) = item.getItemInfo(index);
        Assert.equal(price, 1, "expected 1");
    }
}