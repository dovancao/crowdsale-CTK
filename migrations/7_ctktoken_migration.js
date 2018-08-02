var CTKToken = artifacts.require("./CTKToken.sol");

module.exports = function(deployer) {
  deployer.deploy(CTKToken);
};
