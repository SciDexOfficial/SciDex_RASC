const Store = artifacts.require("RASC_Store")
let address = '0x61b79d1052154a32717fd318ca8b6c76c62bb2e7'
contract("Tesm tests", async (accounts) => {
    // it("getItemCategoriesCount", async() => {
    //     console.log(accounts)
    //     assert.equal(1,2,"" + accounts)
    //     let instance = await Store.at(address)
    //     let count = (await instance.getItemCategoriesCount.call(0)).toNumber()
    //     assert.equal(count, 2, "incorrect value " + count)
    //     // for (var i = 0; i < count; i++) {
    //     //     let subCount = (await instance.getItemSubcategoriesCount.call(0, i)).toNumber()
    //     //     console.log(subCount);
    //     // }
    // })
    it("buy item", async() => {
        let instance = await Store.at(address)//.deployed()
        await instance.buyItem(1, [0, 0, 1], [0, 1, 0])
        let items = await instance.getBoughtItems.call()
        assert.equal(items.length, 3, "incorrect value " + items)
    })
})