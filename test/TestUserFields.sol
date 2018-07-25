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
}