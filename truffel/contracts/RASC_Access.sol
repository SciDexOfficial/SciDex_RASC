pragma solidity ^0.4.23;

contract RASC_Access {
    //basic access 
    struct Access {
        uint accessType;
        uint minValue;
        uint maxValue;
        uint multiplier;
    } 
}