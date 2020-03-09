const Migrations = artifacts.require("Loan");

module.exports = function(deployer) {
  deployer.deploy(Loan);
};