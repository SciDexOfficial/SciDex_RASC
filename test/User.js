const User = artifacts.require("RASC_User")

contract("Testing UserFields contract", async (accounts) => {
    it("getMyIndex for not existing user test", async() => {
        let instance = await User.deployed()
        // try {
        //     let a = await instance.getUserIndex.call(accounts[0])
        //     assert.fail("should be error" + a)
        // } catch (error) {

        // }
    })
    // it("createUser test", async() => {
    //     let instance = await User.deployed()
    //     await instance.createUser("name", "nickname", "description", 123)
    //     try {
    //         let index = await instance.getMyIndex.call()
    //         assert.equal(index.toNumber(), 0, "incorrect index")
    //     } catch (error) {
    //         assert.fail("should return index")
    //     }
    // })
    //getUserInfo
    //getMyIndex
    //addWalletToUser
    //getMyWallets
})