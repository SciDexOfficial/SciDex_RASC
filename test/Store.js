const Store = artifacts.require("RASC_Store")

contract("Testing Store contract", async (accounts) => {
    it("create item test", async() => {
        let instance = await Store.deployed()
        let itemsCountBefore = await instance.getItemsCount.call()
        await instance.createItem("http://test/link/", 12, {from: accounts[0]})
        let itemsCount = await instance.getItemsCount.call()
        
        assert.equal(itemsCount.toNumber(), itemsCountBefore.toNumber() + 1, "cannot create item")
    })
    it("get item test", async() => {
        let instance = await Store.deployed()
        let info = await instance.getItemInfo.call(0)
        assert.equal(info[1], 12, "incorrect price")
        assert.equal(info[2], accounts[0], "incorrect seller address")
    })
    it("get created items test", async() => {
        let instance = await Store.deployed()
        let items = await instance.getCreatedItems.call()
        assert.equal(items[0].toNumber(), 0, "incorrect value " + items[0].toNumber())
    })
})