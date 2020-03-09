const Loan = artifacts.require("Loan");
const Organization = artifacts.require("Organization");
const User = artifacts.require("User");

module.exports = function(deployer) {
  deployer.deploy(Loan);
  deployer.deploy(Organization);
  deployer.deploy(User);
};
