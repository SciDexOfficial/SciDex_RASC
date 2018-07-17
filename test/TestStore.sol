import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RASC_Store.sol";

contract TestStore {
    
    uint public initialBalance = 10 ether;

    function testCheckingEmptyState() public {
        RASC_Store store = RASC_Store(DeployedAddresses.RASC_Store());
        uint[] memory items = store.getBoughtItems();
        Assert.equal(items.length, 0, "should be 0");
    }
    function testCreateNewGroups() public {
        RASC_Store store = RASC_Store(DeployedAddresses.RASC_Store());
        store.createUser("testUser");
        for (uint i = 0; i < 10; i++) {
            uint index0 = store.createItem("item00", 0.5 ether);
            uint index1 = store.createItem("item01", 0.5 ether);
            uint[] memory items = new uint[](2);
            items[0] = index0;
            items[1] = index1;
            store.createGroup(items, 1 ether);
        }
        uint[] memory ids = store.getItemsGroupIds();
        Assert.equal(ids.length, 10, "should be 10");
    }
    function testTryToBuyGroup() public {
        RASC_Store store = RASC_Store(DeployedAddresses.RASC_Store());
        store.buyItemGroup.value(1 ether)(0);
        Assert.equal(address(store).balance, 1 ether, "cannot buy items");
    }
    function testCheckingBoughtItems() public {
        RASC_Store store = RASC_Store(DeployedAddresses.RASC_Store());
        uint[] memory items = store.getBoughtItems();
        Assert.equal(items.length, 2, "should be 2");
    }
    function testCheckingCreatedItems() public {
        RASC_Store store = RASC_Store(DeployedAddresses.RASC_Store());
        uint[] memory items = store.getCreatedItems();
        Assert.equal(items.length, 20, "should be 20");
    }
}