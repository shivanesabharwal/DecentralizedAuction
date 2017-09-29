var DecentAuction = artifacts.require("./DecentralizedAuction.sol");
module.exports = function(deployer) {
  deployer.deploy(DecentAuction);
};
