var ArrayUtils = artifacts.require("./ArrayUtils.sol");
var StringUtils = artifacts.require("./StringUtils.sol");
var SafeMath = artifacts.require("./SafeMath.sol");
var Ownable = artifacts.require("./Ownable.sol");

var RASC_Access = artifacts.require("./RASC_Access.sol");
var RASC_UserFields = artifacts.require("./RASC_UserFields.sol");
var RASC_User = artifacts.require("./RASC_User.sol");
var RASC_Item = artifacts.require("./RASC_Item.sol");
var RASC_Transaction = artifacts.require("./RASC_Transaction.sol");
var RASC_Store = artifacts.require("./RASC_Store.sol");
var RASC_StoreTest = artifacts.require("./RASC_StoreTest.sol");

module.exports = function(deployer, network) {
  deployer.deploy(Ownable);
  deployer.deploy(SafeMath);
  deployer.deploy(StringUtils);
  deployer.deploy(ArrayUtils);

  deployer.link(SafeMath, RASC_Item);
  deployer.link(StringUtils, RASC_Item);
  deployer.link(ArrayUtils, RASC_Item);

  deployer.link(SafeMath, RASC_Store);
  
  deployer.link(ArrayUtils, RASC_User);
  
  deployer.deploy(RASC_Access);
  deployer.deploy(RASC_UserFields);
  deployer.deploy(RASC_User);
  deployer.deploy(RASC_Item);
  deployer.deploy(RASC_Transaction);
  deployer.deploy(RASC_Store);
  
  if (network == "local") {
    deployer.deploy(RASC_StoreTest);
  }
};