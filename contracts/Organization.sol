pragma solidity >=0.4.21 <0.7.0;

/**
 * The contractName contract does this and that...
 */


import "./Loan.sol";
 
contract Organization{
  constructor() public {
 	   
  }
  
  function createLoan (address _userAddress,uint128 _amount) public returns(bool)  {
    Loan myLoan;
    myLoan.setloanReceiver(_userAddress);
    myLoan.setLoanAmount(_amount);
  	return true;
  }
  function getLoanAmount () internal returns(uint128)  {
  	 
  }
  function inquiry () public{
   }
  
}