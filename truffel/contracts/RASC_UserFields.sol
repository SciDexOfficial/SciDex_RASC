pragma solidity ^0.4.23;

contract RASC_UserFields {
    struct UserFieldValue {
        uint intValue;
        string stringValue;
    }
    mapping (uint => mapping(uint => UserFieldValue)) usersFieldDictionary;
    function getFieldValue(uint accessType, uint value) public view returns(uint, string) {
        UserFieldValue memory fieldValue = usersFieldDictionary[accessType][value];
        return (fieldValue.intValue, fieldValue.stringValue);
    }
}