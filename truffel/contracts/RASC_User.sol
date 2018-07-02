pragma solidity ^0.4.23;

contract RASC_User {
    //basic user description
    struct User {
        string name;
        address wallet;
        uint[] accessFields;
    }
    User[] users;
    mapping(address => uint) usersIds;
    function getUser(address userAddress) internal view returns(User) {
        uint userId = usersIds[userAddress];
        return users[userId];
    }
    function getValueForAccess(User memory user, uint accessType) internal pure returns(uint) {
        return user.accessFields[accessType];
    }
}