import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RASC_Store.sol";

contract TestStore {
    
    uint public initialBalance = 10 ether;

    function beforeAll() public {
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
    }
    function test1() public {
        RASC_Store store = RASC_Store(DeployedAddresses.RASC_Store());
        uint[] memory ids = store.getItemsGroupIds();
        Assert.isAbove(ids.length, 9, "more than 10 items created");
    }
    function test2() public {
        RASC_Store store = RASC_Store(DeployedAddresses.RASC_Store());
        store.buyItemGroup.value(1 ether)(0);
        Assert.equal(address(store).balance, 1 ether, "cannot buy items");
    }
}