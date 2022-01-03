let MoolahCoin = artifacts.require("MoolahCoin.sol");

module.exports = function(_deployer) {
  // Use deployer to state migration tasks.
  _deployer.deploy(MoolahCoin);
};
