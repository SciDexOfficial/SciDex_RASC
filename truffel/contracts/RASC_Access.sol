pragma solidity ^0.4.23;

import "./SafeMath.sol";

contract RASC_Access {
    //basic access 
    using SafeMath for uint;
    struct Access {
        uint accessType;
        uint minValue;
        uint maxValue;
        uint multiplier;
    }
}