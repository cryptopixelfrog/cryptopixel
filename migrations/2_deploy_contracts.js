var Cryptopixel = artifacts.require("./Cryptopixel.sol");

module.exports = function(deployer) {
  deployer.deploy(Cryptopixel);
};
