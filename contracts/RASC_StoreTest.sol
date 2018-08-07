pragma solidity ^0.4.23;

import "./RASC_Store.sol";

contract RASC_StoreTest is RASC_Store {
    //test functions
    function convertStringToArrayTest(string memory str, string delim) public pure returns(string memory s) {
        string[] memory arr = str.split(delim);
        if (arr.length == 0) {
            s = "empty_array";
        } else {
            s = arr[0];
        }
    }
    function getPriceTest(
        uint itemIndex, 
        uint[] memory categories, 
        uint[] memory subcategories) public view returns(uint price) {
        price = getItemPrice(itemIndex, categories, subcategories); 
    }
}