const Store = artifacts.require("RASC_Store")

contract("Testing Store contract", async (accounts) => {
    it("create item test", async() => {
        let instance = await Store.deployed()
        let itemsCountBefore = await instance.getItemsCount.call()
        await instance.createItem("http://test/link/", 12, "cat0,v1,v2,v3;cat1,v1,v2;cat2,v,vv", {from: accounts[0]})
        let itemsCount = await instance.getItemsCount.call()
        let category0 = (await instance.getItemCategory.call(0, 0)).toString()
        let category1 = (await instance.getItemCategory.call(0, 1)).toString()
        let category2 = (await instance.getItemCategory.call(0, 2)).toString()
        assert.equal(category0, "cat0", "" + category0)
        assert.equal(category1, "cat1", "" + category1)
        assert.equal(category2, "cat2", "" + category2)

        var subcategoriesCount = (await instance.getItemSubcategoriesCount.call(0, 0)).toNumber()
        assert.equal(subcategoriesCount, 3, "subcategories error " + subcategoriesCount)
        
        var subcategory = (await instance.getItemSubcategory.call(0, 0, 0)).toString()
        assert.equal(subcategory, "v1", "" + category0)
        
        subcategory = (await instance.getItemSubcategory.call(0, 0, 1)).toString()
        assert.equal(subcategory, "v2", "" + category0)

        subcategory = (await instance.getItemSubcategory.call(0, 0, 2)).toString()
        assert.equal(subcategory, "v3", "" + category0)

        subcategory = (await instance.getItemSubcategory.call(0, 2, 0)).toString()
        assert.equal(subcategory, "v", "" + category0)

        subcategory = (await instance.getItemSubcategory.call(0, 2, 1)).toString()
        assert.equal(subcategory, "vv", "" + category0)

        assert.equal(itemsCount.toNumber(), itemsCountBefore.toNumber() + 1, "cannot create item")
    })
    it("create second item test", async() => {
        let instance = await Store.deployed()
        let itemsCountBefore = await instance.getItemsCount.call()
        await instance.createItem("http://test2/link/", 12 * 2, "category1,subcategory,sub0,sub1,sub2;category2,subcategory2,v1,v2,v3", {from: accounts[3]})
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
        let index = (await instance.getItemsCount.call()).toNumber()
        await instance.createItem("http://test2/link1/", 33, "category1,subcategory;category2,subcategory2", {from: accounts[3]})
        let category1 = await instance.getItemCategory.call(index, 0)
        let category2 = await instance.getItemCategory.call(index, 1)
        assert.equal(category1.toString(), "category1", "incorrect category")
        assert.equal(category2.toString(), "category2", "incorrect category")
    })
    it("addSubcategory test", async() => {
        let instance = await Store.deployed()
        let catCountBefore1 = await instance.getItemSubcategoriesCount.call(0, 0)
        let catCountBefore2 = await instance.getItemSubcategoriesCount.call(0, 1)
        await instance.addSubcategory(0, 0, "subcategory1")
        await instance.addSubcategory(0, 0, "subcategory2")
        await instance.addSubcategory(0, 1, "subcategory1")
        await instance.addSubcategory(0, 1, "subcategory2")
        await instance.addSubcategory(0, 1, "subcategory3")
        let catCount1 = await instance.getItemSubcategoriesCount.call(0, 0)
        let catCount2 = await instance.getItemSubcategoriesCount.call(0, 1)
        assert.equal(catCount1.toNumber(), catCountBefore1.toNumber() + 2, "cannot add subcategory")
        assert.equal(catCount2.toNumber(), catCountBefore2.toNumber() + 3, "cannot add subcategory")
    })
    it("getItemSubcategory test", async() => {
        let instance = await Store.deployed()
        let index = (await instance.getItemsCount.call()).toNumber()
        await instance.createItem("http://test2/link1/", 33, "category1,subcategory1,subcategory2;category2,subcategory2", {from: accounts[3]})
        let subcategory1 = await instance.getItemSubcategory.call(index, 0, 0)
        let subcategory2 = await instance.getItemSubcategory.call(index, 0, 1)
        assert.equal(subcategory1.toString(), "subcategory1", "incorrect subcategory")
        assert.equal(subcategory2.toString(), "subcategory2", "incorrect subcategory")
    })
    // it("getItemPrice for subcategories test", async() => {
    //     let instance = await Store.deployed()
    //     let itemPrice = (await instance.getItemPrice.call(0, [], [])).toNumber()
    //     let price1 = (await instance.getItemPrice.call(0, [0], [0])).toNumber()
    //     assert.equal(price1, itemPrice / 2.0, "incorrect price")
    //     let price2 = (await instance.getItemPrice.call(0, [1], [0])).toNumber()
    //     assert.equal(price2, itemPrice / 3.0, "incorrect price")
    //     let price3 = (await instance.getItemPrice.call(0, [0, 1], [0, 0])).toNumber()
    //     assert.equal(price3, itemPrice / 3.0 / 2.0, "incorrect price")
    //     let price4 = (await instance.getItemPrice.call(0, [0, 0], [0, 1])).toNumber()
    //     assert.equal(price4, itemPrice , "incorrect price")
    //     let price5 = (await instance.getItemPrice.call(0, [0, 1, 1], [0, 0, 1])).toNumber()
    //     assert.equal(price5, itemPrice / 3.0, "incorrect price")
    // })
    it("getStoreItems all test", async() => {
        let instance = await Store.deployed()
        let count = (await instance.getItemsCount.call()).toNumber()
        let items = await instance.getStoreItems.call(0, count)
        assert.equal(items[0].toNumber(), count, "" + items[0].toNumber())
    })
    it("buy item test", async() => {
        let instance = await Store.deployed()
        let info = await instance.getItemInfo.call(1)
        await instance.buyItem(1, [0, 0, 1], [0, 1, 0], {from: accounts[1], value: info[1]})
        let items = await instance.getBoughtItems.call({from: accounts[1]})
        assert.equal(items[0].toNumber(), 1, "incorrect value " + items[0].toNumber())
    })
    // it("buyItem with subcategories", async() => {

    // })

    ///
    
    
    // it("convertStringToArray1", async() => {
    //     let instance = await Store.deployed()
    //     let count = await instance.convertStringToArray.call("asdasd sdasdasd  1111  23232  234323 dsdad", "  ", 0)
    //     assert.equal(count.toString(), "asdasd sdasdasd", "incorrect lib " + count.toString())
    // })
    // it("convertStringToArray2", async() => {
    //     let instance = await Store.deployed()
    //     let count = await instance.convertStringToArray.call("asdasd sdasdasd  1111  23232  234323 dsdad", "  ", 1)
    //     assert.equal(count.toString(), "1111", "incorrect lib " + count.toString())
    // })
    // it("convertStringToArray3", async() => {
    //     let instance = await Store.deployed()
    //     let count = await instance.convertStringToArray.call("asdasd sdasdasd  1111  23232  234323 dsdad", "  ", 2)
    //     assert.equal(count.toString(), "23232", "incorrect lib " + count.toString())
    // })
    // it("convertStringToArray4", async() => {
    //     let instance = await Store.deployed()
    //     let count = await instance.convertStringToArray.call("asdasd sdasdasd  1111  23232  234323 dsdad", "  ", 3)
    //     assert.equal(count.toString(), "234323 dsdad", "incorrect lib " + count.toString())
    // })
})