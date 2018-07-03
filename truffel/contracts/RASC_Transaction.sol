pragma solidity ^0.4.23;

import "./RASC_ItemsGroup.sol";

contract RASC_Transaction is RASC_ItemsGroup {
    enum TransactionStatus {created, canceled}
    //item transaction from seller to buyer
    struct Transaction {
        address arbiter;
        address buyer;
        address seller;
        uint itemsGroupIndex;
        TransactionStatus status;
        uint createDate;
        uint updateDate;
    }
    //store all transactions
    Transaction[] transactions;

    //mapping transaction index with seller address
    mapping(address => uint[]) sellersTransactions;

    //mapping transaction index with buyer address
    mapping(address => uint[]) buyersTransactions;
    
    modifier onlyArbiter(uint transactionIndex) {
        Transaction memory transaction = getTransaction(transactionIndex);
        require(transaction.arbiter == msg.sender);
        _;
    }
    
    function createTransaction(address buyer, address seller, uint groupIndex) internal returns(uint) {
        require(buyer != address(0));
        require(seller != address(0));
        require(buyer != seller);
        require(msg.sender != buyer);
        require(msg.sender != seller);
        Transaction memory transaction = Transaction(msg.sender, buyer, seller, groupIndex, TransactionStatus.created, now, now);
        uint index = transactions.push(transaction) - 1;
        sellersTransactions[seller].push(index);
        buyersTransactions[buyer].push(index);
        return index;
    }
    // function confirmTransaction(uint transactionId) public pure onlyArbiter(transactionId) {

    // }
    function cancelTransaction(uint transactionIndex) public onlyArbiter(transactionIndex) {
        Transaction storage transaction = transactions[transactionIndex];
        transaction.status = TransactionStatus.canceled;
    }

    function getTransaction(uint index) internal view returns(Transaction memory transaction) {
        require(transactions.length > index);
        transaction = transactions[index];
    }
    function getTransactionsCount() public view returns(uint) {
        return transactions.length;
    }
    function getTransactionInfo(uint index) public view returns(address, address, address, TransactionStatus, uint, uint, uint[]) {
        Transaction memory transaction = getTransaction(index);
        ItemsGroup memory group = getItemsGroup(transaction.itemsGroupIndex);
        return (transaction.arbiter, 
            transaction.buyer, 
            transaction.seller, 
            transaction.status, 
            transaction.createDate, 
            transaction.updateDate, 
            group.itemsIndexies
            );
    } 
    function getTransactionStatus(uint index) public view returns(TransactionStatus) {
        Transaction memory transaction = getTransaction(index);
        return transaction.status;
    }
    function getTransactionItems(uint index) public view returns(uint[]) {
        Transaction memory transaction = getTransaction(index);
        ItemsGroup memory group = getItemsGroup(transaction.itemsGroupIndex);
        return group.itemsIndexies;
    }
}