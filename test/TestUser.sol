pragma solidity ^0.4.23;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RASC_User.sol";

contract TestUser {

    function testCreatingUser() public {
        RASC_User user = RASC_User(DeployedAddresses.RASC_User());
        uint index = user.createUser("username");
        string memory name;
        address wallet;
        (name, wallet) = user.getUserInfo(index);
        Assert.equal(name, "username", "expected 'username'");
    }

    function testCheckingUserName() public {
        RASC_User user = RASC_User(DeployedAddresses.RASC_User());
        string memory name;
        address wallet;
        (name, wallet) = user.getUserInfo(0);
        Assert.equal(name, "username", "expected 'username'");
    }

    function testGetingUserIndex() public {
        RASC_User user = RASC_User(DeployedAddresses.RASC_User());
        uint index = 100;
        index = user.getMyIndex();
        Assert.equal(index, 0, "expected 0");
    }
}