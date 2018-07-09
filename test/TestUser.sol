pragma solidity ^0.4.23;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RASC_User.sol";

contract TestUser {
    function testa() public pure {
        require(1 == 1);
    }

    function testb() public pure {
        require(false);
    }

    // function test1() public {
    //     RASC_User meta = RASC_User(DeployedAddresses.RASC_User());
    //     uint expected = 0;
    //     meta.createUser("Test1");
    //     Assert.equal(0, expected, "1 not 0");
    // }
}