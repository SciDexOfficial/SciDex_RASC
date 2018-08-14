const Store = artifacts.require("RASC_Store")

var TestData = require("./TestData")
let totalCount = 100
let address = '0xe58fa2c89f067cc7fced628a5490a5b200cb645a'
contract("Filling data", async (accounts) => {
    for (var j = 0; j < totalCount; j++) {
        let i = j
        it("test data " + i, async() => {
            let instance = await Store.at(address)//.deployed()
            await instance.createItem("http://test/link/" + i, TestData.title[i], TestData.description[i], 0, TestData.author[i], TestData.rating[i], TestData.categories[i], (TestData.domain[i] + ";" + TestData.tagsseperatedby[i]).replace(/, /g, ","))
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
        let instance = await Store.at(address)//.deployed()
        let itemsCount = await instance.getItemsCount.call()
        assert.equal(totalCount, itemsCount, "something went wrong")
    })
})