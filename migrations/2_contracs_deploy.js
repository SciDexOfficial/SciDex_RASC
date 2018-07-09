var Ownable = artifacts.require("./Ownable.sol");
var SafeMath = artifacts.require("./SafeMath.sol");
var RASC_Access = artifacts.require("./RASC_Access.sol");
var RASC_UserFields = artifacts.require("./RASC_UserFields.sol");
var RASC_User = artifacts.require("./RASC_User.sol");
var RASC_Item = artifacts.require("./RASC_Item.sol");
var RASC_ItemsGroup = artifacts.require("./RASC_ItemsGroup.sol");
var RASC_Transaction = artifacts.require("./RASC_Transaction.sol");
var RASC_Store = artifacts.require("./RASC_Store.sol");


module.exports = function(deployer) {
  deployer.deploy(Ownable);
  deployer.deploy(SafeMath);
  deployer.deploy(RASC_Access);
  deployer.deploy(RASC_UserFields);
  deployer.deploy(RASC_User);
  deployer.deploy(RASC_Item);
  deployer.deploy(RASC_ItemsGroup);
  deployer.deploy(RASC_Transaction);
  deployer.deploy(RASC_Store);
};