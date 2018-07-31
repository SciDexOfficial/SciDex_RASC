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
    it("addCategory test", async() => {
        let instance = await Store.deployed()
        let catCountBefore = await instance.getItemCategoriesCount.call(0)
        await instance.addCategory(0, "category1")
        await instance.addCategory(0, "category2")
        let catCount = await instance.getItemCategoriesCount.call(0)
        assert.equal(catCount.toNumber(), catCountBefore.toNumber() + 2, "cannot create category")
    })
    it("getItemCategory test", async() => {
        let instance = await Store.deployed()
        let category1 = await instance.getItemCategory.call(0, 0)
        let category2 = await instance.getItemCategory.call(0, 1)
        assert.equal(category1.toString(), "category1", "incorrect category")
        assert.equal(category2.toString(), "category2", "incorrect category")
    })
    it("addSubcategory test", async() => {
        let instance = await Store.deployed()
        let catCountBefore = await instance.getItemSubcategoriesCount.call(0, 0)
        await instance.addSubcategory(0, 0, "subcategory1")
        await instance.addSubcategory(0, 0, "subcategory2")
        let catCount = await instance.getItemSubcategoriesCount.call(0, 0)
        assert.equal(catCount.toNumber(), catCountBefore.toNumber() + 2, "cannot add subcategory")
    })
    it("getItemSubcategory test", async() => {
        let instance = await Store.deployed()
        let subcategory1 = await instance.getItemSubcategory.call(0, 0, 0)
        let subcategory2 = await instance.getItemSubcategory.call(0, 0, 1)
        assert.equal(subcategory1.toString(), "subcategory1", "incorrect subcategory")
        assert.equal(subcategory2.toString(), "subcategory2", "incorrect subcategory")
    })

})