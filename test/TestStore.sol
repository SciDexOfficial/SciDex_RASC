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
}