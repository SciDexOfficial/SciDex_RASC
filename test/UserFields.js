const UserFields = artifacts.require("RASC_UserFields");

contract("Testing UserFields contract", async (accounts) => {
    it("creating new fields type", async () => {
        let instance = await UserFields.deployed();
        let index = await instance.addFieldType.call("dddd", {from: accounts[0]});
        assert.equal(index, 0, "cannot create");
    })
    it("")
})