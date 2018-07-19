const UserFields = artifacts.require("RASC_UserFields");

contract("Testing UserFields contract", async (accounts) => {
    it("check owner", async() => {
        let instance = await UserFields.deployed()
        let owner = await instance.getOwner()
        assert.equal(owner, accounts[0], "problem with owner " + owner)
    })
    it("creating new fields type", async () => {
        let instance = await UserFields.deployed()
        let count = await instance.getFildsTypesCount.call()
        let index1 = await instance.addFieldType("dddd1", {from: accounts[0]})
        let index2 = await instance.addFieldType("dddd2", {from: accounts[0]})
        let countNew = await instance.getFildsTypesCount.call()
        assert.equal(count.toNumber() + 2, countNew.toNumber(), "cannot create" + index1 + index2)
    })
    it("should not create new type", async() => {
        let instance = await UserFields.deployed()
        let err = null
        try {
            await instance.addFieldType.call("dddd", {from: accounts[1]})
        } catch (error){
            err = error
        }
        
        assert.ok(err instanceof Error, "doesn't get error")
    })

})