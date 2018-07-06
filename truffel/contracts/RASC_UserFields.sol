pragma solidity ^0.4.23;

import "./Ownable.sol";

contract RASC_UserFields is Ownable {
    //events

    event FieldTypeCreated(uint fieldIndex, string description);

    //basic dictionary to convert user's fields value to general view
    struct UserFieldValue {
        uint intValue;
        string stringValue;
    }

    //key0: field type
    //key1: one of posible values for this field
    //value: description of this value 
    mapping (uint => mapping(uint => UserFieldValue)) usersFieldsValueDictionary;
    
    //key: field type
    //value: description
    string[] usersFieldsDescription;

    //get description for field value
    function getFieldValueDescription(uint fieldType, uint value) public view returns(uint, string) {
        UserFieldValue memory fieldValue = usersFieldsValueDictionary[fieldType][value];
        return (fieldValue.intValue, fieldValue.stringValue);
    }
    //get field description
    function getFieldDescription(uint fieldType) public view returns(string) {
        return usersFieldsDescription[fieldType];
    }
   
    //get count of fields
    function getFildsTypesCount() public view returns(uint) {
        return usersFieldsDescription.length;
    }
    
    //only contract owner
    //add new value descriptions
    function setFieldValueDescription(uint fieldType, uint value, uint intValue, string stringValue) public onlyOwner {
        require(usersFieldsDescription.length > fieldType);
        UserFieldValue storage field = usersFieldsValueDictionary[fieldType][value];
        field.intValue = intValue;
        field.stringValue = stringValue;
    }

    //add new field type
    function addFieldType(string description) public onlyOwner returns(uint index) {
        index = usersFieldsDescription.push(description) - 1;
        
        emit FieldTypeCreated(index, description);
    }
}