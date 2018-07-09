pragma solidity ^0.4.23;

contract RASC_User {
    //events

    event UserCreated(uint userIndex, string name, address wallet);
    event UserUpdatedProfile(uint userIndex);
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
    
    //create new user
    function createUser(string name) public returns(uint index) {
        //check if user exist
        require(usersIndexies[msg.sender] == 0);
        
        //check with first user
        if (users.length > 0) {
            require(users[0].wallet != msg.sender);
        }
        
        User memory user = User(name, msg.sender);
        index = users.push(user) - 1;

        emit UserCreated(index, name, msg.sender);
    }
 
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
    function updateMyProfile(uint[] memory types, uint[] memory values) public {
        require(types.length == values.length);
        uint userIndex = getUserIndex(msg.sender);
        User memory user = users[userIndex];
        require(user.wallet == msg.sender);

        uint typesCount = types.length;
        for (uint i = 0; i < typesCount; i++) {
            usersFields[userIndex][types[i]] = values[i];
        }

        emit UserUpdatedProfile(userIndex);
    }
}