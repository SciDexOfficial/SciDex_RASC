const Store = artifacts.require("RASC_Store")

var TestData = require("./TestData")
let totalCount = 100
let address = '0xB33f23Fce281794a9AdA380fEb1D7bcBedE165D8'
contract("Filling data", async (accounts) => {
    for (var j = 0; j < totalCount; j++) {
        let i = j
        it("test data " + i, async() => {
            let instance = await Store.at(address)//.deployed()
            await instance.createItem("http://test/link/" + i, TestData.title[i], TestData.description[i], 0, TestData.author[i], TestData.rating[i], "", TestData.tagsseperatedby[i])
            console.log("done: " + TestData.index[i]);
        })
    }
    it("check total count", async() => {
        let instance = await Store.at(address)//.deployed()
        let itemsCount = await instance.getItemsCount.call()
        assert.equal(totalCount, itemsCount, "something went wrong")
    })
})