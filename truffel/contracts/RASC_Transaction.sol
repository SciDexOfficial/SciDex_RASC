pragma solidity ^0.4.23;

import "./RASC_ItemsGroup.sol";

contract RASC_Transaction is RASC_ItemsGroup {
    //item transaction from seller to buyer
    
    struct Transaction {
        address arbiter;
        ItemsGroup items;
        address buyer;
        address seller;
        uint status;
        uint createDate;
        uint updateDate;
    }

    Transaction[] transactions;
    mapping(address => uint[]) sellersTransactions;
    mapping(address => uint[]) buyersTransactions;
    // modifier onlyArbiter(Transaction transaction) {
    //     require(transaction.arbiter == msg.sender);
    //     _;
    // }
    
    // function createTransaction() internal pure {

    // }
    // function confirmTransaction(uint transactionId) public pure onlyArbiter(transactionId) {

    // }
    // function cancelTransaction() public view {

    // }

    function getTransaction(uint index) internal view returns(Transaction) {
        require(transactions.length > index);
        return transactions[index];
    }
    function getTransactionsCount() public view returns(uint) {
        return transactions.length;
    }
    function getTransactionInfo(uint index) public view returns(address, address, address, uint, uint, uint, uint[]) {
        Transaction memory transaction = getTransaction(index);
        return (transaction.arbiter, 
            transaction.buyer, 
            transaction.seller, 
            transaction.status, 
            transaction.createDate, 
            transaction.updateDate, 
            transaction.items.itemsIndexies
            );
    } 
    function getTransactionStatus(uint index) public view returns(uint) {
        Transaction memory transaction = getTransaction(index);
        return transaction.status;
    }
    function getTransactionItems(uint index) public view returns(uint[]) {
        Transaction memory transaction = getTransaction(index);
        return transaction.items.itemsIndexies;
    }
}