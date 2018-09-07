const Item = artifacts.require("RASC_Item")

var TestData = require("./TestData")
let totalCount = 100
let address = '0x27ccd3b2dd09491d9cb9b33c34da7e292ff1d3c7'
contract("Filling data", async (accounts) => {
    for (var j = 0; j < totalCount; j++) {
        let i = j
        it("test data " + i, async() => {
            let instance = await Item.at(address)//.deployed()
            await instance.createItem("http://test/link/" + i, TestData.title[i], TestData.description[i], TestData.price[i], TestData.author[i], TestData.size[i], TestData.categories[i], (TestData.domain[i] + ";" + TestData.tagsseperatedby[i]).replace(/, /g, ","))
            console.log("done: " + TestData.index[i]);
            // console.log(TestData.title[i])
            // console.log(TestData.description[i])
            // console.log(TestData.author[i]) 
            // console.log(TestData.rating[i])
            // console.log(TestData.categories[i]) 
            // console.log((TestData.domain[i] + ";" + TestData.tagsseperatedby[i]).replace(/, /g, ","))
        })
    }
    it("check total count", async() => {
        let instance = await Item.at(address)//.deployed()
        let itemsCount = await instance.getItemsCount.call()
        assert.equal(totalCount, itemsCount, "something went wrong")
    })
})