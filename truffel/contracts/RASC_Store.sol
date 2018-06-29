pragma solidity ^0.4.23;

import "./SafeMath.sol";
import "./RASC_User.sol";
import "./RASC_ItemsGroup.sol";

contract RASC_Store is RASC_ItemsGroup, RASC_User {
    using SafeMath for uint;
}