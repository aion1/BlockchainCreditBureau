const Loan = artifacts.require("Loan");
const Organization = artifacts.require("Organization");
const User = artifacts.require("User");
const Accounts = artifacts.require("Accounts");

module.exports = function(deployer) {
  deployer.deploy(Loan);
  deployer.deploy(Organization);
  deployer.deploy(Accounts);
  deployer.deploy(User);
};
