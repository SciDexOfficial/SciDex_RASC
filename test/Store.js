const Store = artifacts.require("RASC_Store")

contract("Testing Store contract", async (accounts) => {
    it("create item test", async() => {
        let instance = await Store.deployed()
        let itemsCountBefore = await instance.getItemsCount.call()
        await instance.createItem("http://test/link/", 12, {from: accounts[0]})
        let itemsCount = await instance.getItemsCount.call()
        
        assert.equal(itemsCount.toNumber(), itemsCountBefore.toNumber() + 1, "cannot create item")
    })
    it("create second item test", async() => {
        let instance = await Store.deployed()
        let itemsCountBefore = await instance.getItemsCount.call()
        await instance.createItem("http://test2/link/", 12 * 2, {from: accounts[3]})
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
    it("get item price test", async() => {
        let instance = await Store.deployed()
        let price = await instance.getItemPrice.call("0", [], [])
        assert.equal(price.toNumber(), 12, "incorrect price " + price.toNumber())
    })
    it("buy item test", async() => {
        let instance = await Store.deployed()
        await instance.buyItem(1, [], [], {from: accounts[1], value: 30})
        let items = await instance.getBoughtItems.call({from: accounts[1]})
        assert.equal(items[0].toNumber(), 1, "incorrect value " + items[0].toNumber())
    })
})