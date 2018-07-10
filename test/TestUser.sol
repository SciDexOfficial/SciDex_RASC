pragma solidity ^0.4.23;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RASC_User.sol";

contract TestUser {
    // function testa() public {
    //     // require(1 == 1);
    //     uint expected = 0;
    //     Assert.equal(0, expected, "0 not 1");
    // }

    // function testb() public {
    //     // require(false);
    //     uint expected = 1;
    //     Assert.equal(0, expected, "1 not 0");
    // }

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

    // function test3() public {
    //     RASC_User user = RASC_User(DeployedAddresses.RASC_User());
    //     uint index = user.createUser("3");
    //     string memory name;
    //     address wallet;
    //     (name, wallet) = user.getUserInfo(index);
    //     Assert.equal(name, "3", "expected '3'");
    // }
}