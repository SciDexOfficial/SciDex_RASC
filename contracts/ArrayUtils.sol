pragma solidity ^0.4.23;

library ArrayUtils {
    function contains(uint[] memory array, uint a) internal pure returns(bool) {
        for (uint i = 0; i < array.length; i++ ) {
            if (array[i] == a) {
                return true;
            }
        }
        return false;
    }

    function contains(address[] memory array, address a) internal pure returns(bool) {
        for (uint i = 0; i < array.length; i++ ) {
            if (array[i] == a) {
                return true;
            }
        }
        return false;
    }
    function contains(string[] memory array, string memory a) internal pure returns(bool) {
        for (uint i = 0; i < array.length; i++ ) {
            if (keccak256(abi.encodePacked(array[i])) == keccak256(abi.encodePacked(a))) {
                return true;
            }
        }
        return false;
    }
}