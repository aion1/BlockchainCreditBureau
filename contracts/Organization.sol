pragma solidity >=0.4.21 <0.7.0;

/**
 * The contractName contract does this and that...
 */


import "./Loans.sol";
 
contract Organization{
  address loansContractAddress;
  address loanerAddress;
  constructor() public {
 	   
  }
  
  function createLoan (address _loanie, uint256 _amount, uint128 _installmentsNum, uint128 _interest) public returns(bool)  {
    address loaner = msg.sender;
    loanerAddress = loaner;
    Loans loansContract = Loans(loansContractAddress);
    
    //TRIGGER EVENT TO USER
    // WAIT AN EVENT COMING FROM THE USER IF IT COME ADD
    
    loansContract.add(_loanie, loaner, _amount, false, _installmentsNum, _interest);
  	return true;
  }
  
 
  //To set the (loans contract) address deployed on the chain
  //It should be set before deploying, but will be updated later
  function setLoansContractAddress(address _loansContractAddress) public {
    loansContractAddress=_loansContractAddress;
  }
  
}