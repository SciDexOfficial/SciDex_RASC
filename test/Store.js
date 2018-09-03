const Store = artifacts.require("RASC_StoreTest")

contract("Testing Store contract", async (accounts) => {
    it("create item test", async() => {
        let instance = await Store.deployed()
        let itemsCountBefore = await instance.getItemsCount.call()
        await instance.createItem("http://test/link/", "item1", "item description", 12, "Yurii", 510, "cat0,v1,v2,v3;cat1,v1,v2;cat2,v,vv", "", {from: accounts[0]})
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
        await instance.createItem("http://test2/link/", "title", "some description ...", 12 * 2, "Yurii", 590,  "category1,subcategory,sub0,sub1,sub2;category2,subcategory2,v1,v2,v3", "tag1,tag2,tag3", {from: accounts[3]})
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
        await instance.createItem("http://test2/link1/", "title123", "item description", 33, "Y.Yashchenko", 580, "category1,subcategory;category2,subcategory2", "tag1,tag2", {from: accounts[3]})
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
        await instance.createItem("http://test2/link1/", "noname", "noname description", 33, "Yashchenko", 430, "category1,subcategory1,subcategory2;category2,subcategory2", "tag1", {from: accounts[3]})
        let subcategory1 = await instance.getItemSubcategory.call(index, 0, 0)
        let subcategory2 = await instance.getItemSubcategory.call(index, 0, 1)
        assert.equal(subcategory1.toString(), "subcategory1", "incorrect subcategory")
        assert.equal(subcategory2.toString(), "subcategory2", "incorrect subcategory")
    })
    
    it("getStoreItems all test", async() => {
        let instance = await Store.deployed()
        let count = (await instance.getItemsCount.call()).toNumber()
        let items = await instance.getStoreItems.call(0, count)
        assert.equal(items[0].toNumber(), count, "" + items[0].toNumber())
    })
    it("buy item test", async() => {
        let instance = await Store.deployed()
        let info = await instance.getItemInfo.call(1)
        await instance.buyItem(1, [0, 0, 1], [0, 1, 0], {from: accounts[1], value: 0})
        let items = await instance.getBoughtItems.call({from: accounts[1]})
        assert.equal(items[0].toNumber(), 1, "incorrect value " + items[0].toNumber())
    })
    it("buy item with same categories test ", async() => {
        let instance = await Store.deployed()
        try {
            await instance.buyItem(1, [0, 0, 1], [0, 1, 0], {from: accounts[1], value: 0})
            assert.fail("should be error")
        } catch (error) {

        }
        
    })
    it("get bought item info", async() => {
        let instance = await Store.deployed()
        let item = await instance.getItemInfo.call(1, {from: accounts[1]})
        assert.equal(item[0], "http://test2/link/", "incorrect data " + item[0])
    })
    it("get bought item info for incorrect account", async() => {
        let instance = await Store.deployed()
        let item = await instance.getItemInfo.call(1, {from: accounts[2]})
        assert.equal(item[0], "", "incorrect data " + item[0])
    })
    it("get bought item subcategories", async() => {
        let instance = await Store.deployed()
        let item = await instance.getItemInfo.call(1, {from: accounts[1]})
        assert.equal(item[5][0].toNumber(), 0, "incorrect data")
        assert.equal(item[5][1].toNumber(), 0, "incorrect data")
        assert.equal(item[5][2].toNumber(), 1, "incorrect data")
        assert.equal(item[6][0].toNumber(), 0, "incorrect data")
        assert.equal(item[6][1].toNumber(), 1, "incorrect data")
        assert.equal(item[6][2].toNumber(), 0, "incorrect data")
    })
    it("convertStringToArray1", async() => {
        let instance = await Store.deployed()
        let s = await instance.convertStringToArrayTest.call("asdasd sdasdasd 1111 23232 234323 dsdad", "  ")
        assert.equal(s.toString(), "asdasd sdasdasd 1111 23232 234323 dsdad", "incorrect lib " + s.toString())
    })
    it("convertStringToArray0", async() => {
        let instance = await Store.deployed()
        let s = await instance.convertStringToArrayTest.call("", "  ")
        assert.equal(s.toString(), "empty_array", "incorrect lib " + s.toString())
    })
    ///????????????????????
    it("create item without categories test", async() => {
        let instance = await Store.deployed()
        let itemsCountBefore = await instance.getItemsCount.call()
        await instance.createItem("http://test2/link/", "title", "some description ...", 12 * 2, "Yurii", 510,  "", "tag1,tag2,tag3", {from: accounts[3]})
        let itemsCount = await instance.getItemsCount.call()
        
        assert.equal(itemsCount.toNumber(), itemsCountBefore.toNumber() + 1, "cannot create item")
    })
    it("get item price without categories", async() => {
        let instance = await Store.deployed()
        await instance.createItem("http://test2/link/", "title", "some description ...", 12 * 2, "Yurii", 510,  "", "tag1,tag2,tag3", {from: accounts[3]})
        let itemsCount = (await instance.getItemsCount.call()).toNumber()
        let itemPrice = (await instance.getPriceTest.call(itemsCount - 1, [], [])).toNumber()
        assert.equal(itemPrice, 24, "incorrect price")
    })
    it("getItemPrice for subcategories test", async() => {
        let instance = await Store.deployed()
        await instance.createItem("http://test/link/", "item10", "item description", 12, "Yurii", 510, "cat0,v1,v2,v3;cat1,v1,v2;cat2,v,vv", "", {from: accounts[0]})
        let itemIndex = (await instance.getItemsCount.call()).toNumber() - 1
        let price1 = (await instance.getPriceTest.call(itemIndex, [0, 1, 1, 2, 2], [0, 0, 1, 0, 1])).toNumber()
        assert.equal(price1, 12 / 3.0, "incorrect price 1")
        // let price2 = (await instance.getPriceTest.call(0, [1], [0])).toNumber()
        // assert.equal(price2, itemPrice / 3.0, "incorrect price 2")
        // let price3 = (await instance.getPriceTest.call(0, [0, 1], [0, 0])).toNumber()
        // assert.equal(price3, itemPrice / 3.0 / 2.0, "incorrect price 3")
        // let price4 = (await instance.getPriceTest.call(0, [0, 0], [0, 1])).toNumber()
        // assert.equal(price4, itemPrice , "incorrect price 4")
        // let price5 = (await instance.getPriceTest.call(0, [0, 1, 1], [0, 0, 1])).toNumber()
        // assert.equal(price5, itemPrice / 3.0, "incorrect price 5")
    })
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