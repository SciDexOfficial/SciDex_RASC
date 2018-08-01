pragma solidity ^0.4.23;

library StringUtils {

    function split(string memory _base, string memory _value)
        internal pure
        returns (string[] memory splitArr) {
        bytes memory _baseBytes = bytes(_base);
        uint delimSize = bytes(_value).length;
        uint _offset = 0;
        uint arraySize = splitSize(_base, _value);
        splitArr = new string[](arraySize);
        uint count = 0;
        while(_offset < _baseBytes.length-1) {

            int _limit = indexOf(_base, _value, _offset);
            if (_limit == -1) {
                _limit = int(_baseBytes.length);
            }

            string memory _tmp = new string(uint(_limit)-_offset);
            bytes memory _tmpBytes = bytes(_tmp);

            uint j = 0;
            for(uint i = _offset; i < uint(_limit); i++) {
                _tmpBytes[j++] = _baseBytes[i];
            }
            _offset = uint(_limit) + delimSize;
            splitArr[count] = string(_tmpBytes);
            count++;
        }
    }
    function splitSize(string memory _base, string memory _value) internal pure returns(uint size) {
        bytes memory _baseBytes = bytes(_base);
        bytes memory _valueBytes = bytes(_value);

        assert(_valueBytes.length >= 1);
        size = 1;
        for(uint i = 0; i < _baseBytes.length - _valueBytes.length; i++) {
            bool isEquil = true;
            for (uint j = 0; j < _valueBytes.length; j++) {
                if (_baseBytes[j + i] != _valueBytes[j]) {
                    isEquil = false;
                    break;
                }
            }
            if (isEquil) {
                size++;
            }
        }
    }
    function indexOf(string memory _base, string memory _value, uint _offset)
        internal pure
        returns (int) {
        bytes memory _baseBytes = bytes(_base);
        bytes memory _valueBytes = bytes(_value);

        assert(_valueBytes.length >= 1);

        for(uint i = _offset; i < _baseBytes.length - _valueBytes.length; i++) {
            bool isEquil = true;
            for (uint j = 0; j < _valueBytes.length; j++) {
                if (_baseBytes[j + i] != _valueBytes[j]) {
                    isEquil = false;
                    break;
                }
            }
            if (isEquil) {
                return int(i);
            }
        }

        return -1;
    }
}