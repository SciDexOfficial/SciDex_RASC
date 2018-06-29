pragma solidity ^0.4.23;

import "./RASC_ItemsGroup.sol";

contract RASC_Transaction is RASC_ItemsGroup {
    //item transaction from seller to buyer
    
    struct Transaction {
        address arbiter;
        ItemsGroup items;
    }

    // modifier onlyArbiter(Transaction transaction) {
    //     require(transaction.arbiter == msg.sender);
    //     _;
    // }
    
    function createTransaction() public view {

    }
    function confirmTransaction(uint transactionId) public view {

    }
    function cancelTransaction() public view {

    }
}