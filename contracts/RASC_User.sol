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
    User[] private users;
    //user wallets
    mapping(uint => address[]) private usersWallets;

    //key0:user index
    //key1:type of the field
    //value:field's value
    mapping(uint => mapping(uint => uint)) private usersFields;
    
    //key: user address 
    //value: index of user in the users array
    mapping(address => uint) private usersIndexies;
    
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
        usersIndexies[msg.sender] = index;

        emit UserCreated(index, name, msg.sender);
    }
 
    function getUserInfo(uint index) public view returns(string memory name, address wallet) {
        User memory user = users[index];
        name = user.name;
        wallet = user.wallet;
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
    function getMyIndex() public view returns(uint index) {
        index = getUserIndex(msg.sender);
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