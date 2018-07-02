pragma solidity ^0.4.23;

contract RASC_User {
    //basic user description
    struct User {
        string name;
        address wallet;
    }
    //all registered users
    User[] users;

    //key0:user index
    //key1:type of the field
    //value:field's value
    mapping(uint => mapping(uint => uint)) usersFields;
    
    //key: user address 
    //value: index of user in the users array
    mapping(address => uint) usersIndexies;
    
    //return user from address if exist
    function getUser(address userAddress) internal view returns(User) {
        uint userId = getUserIndex(userAddress);
        return users[userId];
    }
    
    //converting user address to user index
    function getUserIndex(address userAddress) internal view returns(uint) {
        uint userId = usersIndexies[userAddress];
        //check if user exist
        require(users.length > userId);
        return userId;
    }
    //get value for current field type
    function getValueForAccessType(uint userId, uint fieldType) internal view returns(uint) {
        return usersFields[userId][fieldType];
    }
    //updating profile data
    function updateMyData(uint[] memory types, uint[] memory values) public {
        require(types.length == values.length);
        uint userIndex = getUserIndex(msg.sender);
        
        uint typesCount = types.length;
        for (uint i = 0; i < typesCount; i++) {
            usersFields[userIndex][types[i]] = values[i];
        }
    }
}