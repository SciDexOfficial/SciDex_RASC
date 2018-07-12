pragma solidity ^0.4.23;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RASC_User.sol";

contract TestUser {

    function test0() public {
        RASC_User user = RASC_User(DeployedAddresses.RASC_User());
        // user.createUser("1");
        uint index = user.createUser("2");
        string memory name;
        address wallet;
        (name, wallet) = user.getUserInfo(index);
        Assert.equal(name, "2", "expected '2'");
    }

    function test1() public {
        RASC_User user = RASC_User(DeployedAddresses.RASC_User());
        string memory name;
        address wallet;
        (name, wallet) = user.getUserInfo(0);
        Assert.equal(name, "2", "expected '2'");
    }

    function test2() public {
        RASC_User user = RASC_User(DeployedAddresses.RASC_User());
        uint index = 100;
        index = user.getMyIndex();
        Assert.equal(index, 0, "expected 0");
    }
}