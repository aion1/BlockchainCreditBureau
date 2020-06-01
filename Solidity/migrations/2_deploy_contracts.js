const Loans = artifacts.require("Loans");
const Organization = artifacts.require("Organization");
const User = artifacts.require("User");
const Accounts = artifacts.require("Accounts");

module.exports = function(deployer) {
  deployer.deploy(Organization);
  deployer.deploy(Accounts);
  deployer.deploy(User);
  deployer.deploy(Loans);
};
