pragma solidity ^0.4.23;

import "./RASC_Item.sol";
import "./Ownable.sol";

contract RASC_Transaction is RASC_Item, Ownable {
    enum TransactionStatus {created, canceled, confirmed}
    //events
    event TransactionChangedStatus(uint transactionIndex, TransactionStatus status, address executer);
    event TransactionCreated(
        uint transactionIndex,
        address buyer,
        address seller, 
        address arbiter, 
        uint itemIndex, 
        uint amount,
        uint[] categories, 
        uint[] subcategories
    );
    //item transaction from seller to buyer
    struct Transaction {
        address arbiter;
        address buyer;
        address seller;
        uint itemIndex;
        TransactionStatus status;
        bool isPaid;
        uint amount;
        uint createDate;
        uint updateDate;
    }
    //transaction categories
    mapping(uint => mapping(uint => uint[])) transactionsCategories;
    //store all transactions
    Transaction[] private transactions;

    //mapping transaction index with seller address
    mapping(address => uint[]) sellersTransactions;

    //mapping transaction index with buyer address
    mapping(address => uint[]) buyersTransactions;
    
    modifier onlyArbiter(uint transactionIndex) {
        Transaction memory transaction = getTransaction(transactionIndex);
        require(transaction.arbiter == msg.sender);
        _;
    }
    
    function createTransaction(
        address buyer, 
        address arbiter, 
        uint itemIndex, 
        TransactionStatus status,
        uint amount,
        uint[] memory categories, 
        uint[] memory subcategories) internal returns(uint) 
        {
        Item memory item = getItemObject(itemIndex);
        address seller = item.seller;
        require(categories.length == subcategories.length);
        require(buyer != address(0));
        require(seller != address(0));
        require(buyer != seller);
        Transaction memory transaction = Transaction(
            arbiter, 
            buyer, 
            seller, 
            itemIndex, 
            status, 
            false,
            amount,
            now, 
            now
            );
        uint index = transactions.push(transaction) - 1;
        sellersTransactions[seller].push(index);
        buyersTransactions[buyer].push(index);
        
        for (uint i = 0; i < categories.length; i++) {
            if (transactionsCategories[index][categories[i]].contains(subcategories[i]) == false) {
                transactionsCategories[index][categories[i]].push(subcategories[i]);
            }
        }

        emit TransactionCreated(index, buyer, seller, arbiter, itemIndex, amount, categories, subcategories);
        
        return index;
    }

    function payTransaction(uint transactionIndex) payable public {
        // require(msg.value >= transaction.amount);
        Transaction storage transaction = transactions[transactionIndex];
        transaction.isPaid = true;
        // if (msg.value - transaction.amount > 0) {
        //     msg.sender.transfer(msg.value - transaction.amount);
        // }

    }
    function convertTransactionCategoriesToArray(uint index) private view returns(uint[] memory values, uint[] memory valuesKeys) {
        uint subcategoriesCount;
        uint categoriesCount;
        (categoriesCount, subcategoriesCount) = getTransactionSubcategoriesCount(index);
        values = new uint[](subcategoriesCount);
        valuesKeys = new uint[](subcategoriesCount);
        uint key = 0;
        for (uint i = 0; i < categoriesCount; i++) {
            uint transactionsSubcategoriesCount = transactionsCategories[index][i].length;
            for (uint j = 0; j < transactionsSubcategoriesCount; j++) {
                values[key] = transactionsCategories[index][i][j];
                valuesKeys[key] = i;
                key++;
            }
        }
    }
    function getTransactionSubcategoriesCount(uint transactionIndex) private view returns(uint categoriesCount, uint count) {
        count = 0;
        Transaction memory transaction = transactions[transactionIndex];
        categoriesCount = getItemCategoriesCount(transaction.itemIndex);//itemsCategories[transaction.itemIndex].length;
        for (uint i = 0; i < categoriesCount; i++) {
            count += transactionsCategories[transactionIndex][i].length;
        }
    }
    function autoconfirmTransaction(uint transactionIndex, uint[] memory categories, uint[] memory subcategories) internal {
        Transaction memory transaction = transactions[transactionIndex];
        require(transaction.isPaid == true);
        require(transaction.arbiter == address(0));

        transactions[transactionIndex].status = TransactionStatus.confirmed;
        // transaction.seller.transfer(transaction.amount);

        addItemPurchaseToUser(transaction.itemIndex, msg.sender, categories, subcategories);
        emit TransactionChangedStatus(transactionIndex, TransactionStatus.confirmed, msg.sender);
    }
    function confirmTransaction(uint transactionIndex) public onlyArbiter(transactionIndex) {
        //TODO: check if user can confirm
        transactions[transactionIndex].status = TransactionStatus.confirmed;

        emit TransactionChangedStatus(transactionIndex, TransactionStatus.confirmed, msg.sender);
    }
    function cancelTransaction(uint transactionIndex) public onlyArbiter(transactionIndex) {
        Transaction storage transaction = transactions[transactionIndex];
        transaction.status = TransactionStatus.canceled;

        emit TransactionChangedStatus(transactionIndex, TransactionStatus.canceled, msg.sender);
    }

    function getTransaction(uint index) internal view returns(Transaction memory transaction) {
        require(transactions.length > index);
        transaction = transactions[index];
    }
    function getTransactionsCount() public view returns(uint) {
        return transactions.length;
    }
    function getTransactionInfo(uint index) public view returns(address, address, address, TransactionStatus, uint, uint, uint) {
        Transaction memory transaction = getTransaction(index);
        return (transaction.arbiter, 
            transaction.buyer, 
            transaction.seller, 
            transaction.status, 
            transaction.createDate, 
            transaction.updateDate, 
            transaction.itemIndex
            );
    } 
    function getTransactionStatus(uint index) public view returns(TransactionStatus) {
        Transaction memory transaction = getTransaction(index);
        return transaction.status;
    }
    function getTransactionItemIndex(uint index) public view returns(uint) {
        Transaction memory transaction = getTransaction(index);
        return transaction.itemIndex;
    }
    function getTransactionCategories(uint transactionIndex) public view returns(uint[], uint[]) {

    }
}