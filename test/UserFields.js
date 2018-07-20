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
        let index1 = await instance.addFieldType("type1", {from: accounts[0]})
        let index2 = await instance.addFieldType("type2", {from: accounts[0]})
        let countNew = await instance.getFildsTypesCount.call()
        assert.equal(count.toNumber() + 2, countNew.toNumber(), "cannot create" + index1 + index2)
    })
    it("should not create new type", async() => {
        let instance = await UserFields.deployed()
        let err = null
        try {
            await instance.addFieldType.call("type3", {from: accounts[1]})
        } catch (error){
            err = error
        }
        
        assert.ok(err instanceof Error, "doesn't get error")
    })
    it("setFieldValueDescription test", async() => {
        let instance = await UserFields.deployed()
        await instance.setFieldValueDescription(0, 1, 2, "description", {from: accounts[0]})
        let res = await instance.getFieldValueDescription.call(0, 1);
        assert.equal(res[0].toNumber(), 2, "incorrect int value")
        assert.equal(res[1].toString(), "description", "incorrect string value")
    })
    it("getAllFiledsValues test", async() => {
        let instance = await UserFields.deployed()
        let data = await instance.getAllFiledsValues.call(0)
        assert.equal(data[0].toNumber(), 1, "incorrect int value" + data[0].toNumber())
    })

    it("should not setFieldValueDescription for unknown field type test", async() => {
        let instance = await UserFields.deployed()
        let err = null
        try {
            await instance.setFieldValueDescription(2, 1, 2, "description", {from: accounts[0]})
        } catch (error) {
            err = error
        }
        assert.ok(err instanceof Error, "doesn't get error")
    })
    it("should not setFieldValueDescription for not contract owner test", async() => {
        let instance = await UserFields.deployed()
        let err = null
        try {
            await instance.setFieldValueDescription(0, 2, 2, "description", {from: accounts[1]})
        } catch (error) {
            err = error
        }
        assert.ok(err instanceof Error, "doesn't get error")
    })
})