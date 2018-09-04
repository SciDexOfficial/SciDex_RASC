pragma solidity ^0.4.23;

contract RASC_User {
    //events

    event UserCreated(uint userIndex, string name, string nickName, string description, address wallet, uint infoHash);
    event UserAddedWallet(uint userIndex, address wallet);
    event UserUpdatedProfile(uint userIndex);
    //basic user description
    struct User {
        string name;
        string nickName;
        string description;
        address wallet;
        uint infoHash;
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
    function createUser(string name, string nickName, string description, uint infoHash) public returns(uint index) {
        //check if user exist
        bool exist;
        (exist,) = getUserIndex(msg.sender);
        require(exist == false);
        User memory user = User(name, nickName, description, msg.sender, infoHash);
        index = users.push(user) - 1;
        usersIndexies[msg.sender] = index;
        usersWallets[index].push(msg.sender);
        emit UserCreated(index, name, nickName, description, msg.sender, infoHash);
    }
    function getUserInfo(uint index) public view returns(string memory name, address wallet) {
        User memory user = users[index];
        name = user.name;
        wallet = user.wallet;
    }

    //return user from address if exist
    function getUser(address userAddress) internal view returns(User) {
        uint userIndex;
        bool exist;
        (exist, userIndex) = getUserIndex(userAddress);
        return users[userIndex];
    }
    
    // //converting user address to user index
    function getUserIndex(address userAddress) internal view returns(bool exist, uint userIndex) {
        userIndex = usersIndexies[userAddress];
        //check if user exist
        require(users.length > userIndex);
        exist = true;
        
        if (userIndex == 0) {
            if (users[0].wallet == address(0)) {
                exist = false;
            }
        }
    }
    function getMyIndex() public view returns(uint index) {
        bool exist;
        (exist, index) = getUserIndex(msg.sender);
        require(exist);
    }
    //get value for current field type
    function getValueForAccessType(uint userId, uint fieldType) internal view returns(uint) {
        return usersFields[userId][fieldType];
    }
    //updating profile data
    function updateMyProfile(uint[] memory types, uint[] memory values) public {
        require(types.length == values.length);
        uint userIndex;
        bool exist;
        (exist, userIndex) = getUserIndex(msg.sender);
        User memory user = users[userIndex];
        require(user.wallet == msg.sender);

        uint typesCount = types.length;
        for (uint i = 0; i < typesCount; i++) {
            usersFields[userIndex][types[i]] = values[i];
        }

        emit UserUpdatedProfile(userIndex);
    }

    //wallets 
    function addWalletToUser(uint userIndex) public {
        uint index;
        bool exist;
        (exist, index) = getUserIndex(msg.sender);

        require(exist == false);
        usersIndexies[msg.sender] = userIndex;
        usersWallets[userIndex].push(msg.sender);
        emit UserAddedWallet(index, msg.sender);
    }

    // function 
    function getMyWallets() public view returns(address[] memory) {
        uint index;
        bool exist;
        (exist, index) = getUserIndex(msg.sender);
        require(exist);
        return usersWallets[index];
    }

    function test1(uint a) public pure returns(uint) {
        return a + a;
    }
}