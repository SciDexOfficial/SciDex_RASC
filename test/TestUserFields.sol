pragma solidity ^0.4.23;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RASC_UserFields.sol";

contract TestUserFields {
    function beforeEach() public {

    }
    function testCheckingContractOwner() public {
        RASC_UserFields userfields = RASC_UserFields(DeployedAddresses.RASC_UserFields());
        Assert.equal(msg.sender, userfields.getOwner(), "wrong owner");
    }
    function test1() public {
        RASC_UserFields userfields = RASC_UserFields(DeployedAddresses.RASC_UserFields());
        address a1;
        address a2;
        (a1, a2) = userfields.test();
        Assert.equal(msg.sender, a1, "should be true");
    }


    function test2() public {
        RASC_UserFields userfields = RASC_UserFields(DeployedAddresses.RASC_UserFields());
        userfields.addFieldType("dddd");
        uint count = userfields.getFildsTypesCount();
        Assert.equal(count, 1, "1");
    }
}