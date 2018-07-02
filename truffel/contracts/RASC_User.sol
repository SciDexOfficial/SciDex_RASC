pragma solidity ^0.4.23;

contract RASC_User {
    //basic user description
    struct User {
        string name;
        address wallet;
    }
    User[] users;
    mapping(uint => mapping(uint => uint)) usersFields;
    mapping(address => uint) usersIds;
    function getUser(address userAddress) internal view returns(User) {
        uint userId = usersIds[userAddress];
        return users[userId];
    }
    function getValueForAccess(uint userId, uint accessType) internal view returns(uint) {
        return usersFields[userId][accessType];
    }
}