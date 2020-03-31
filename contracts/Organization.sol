pragma solidity >=0.4.21 <0.7.0;

/**
 * The contractName contract does this and that...
 */


import "./Loans.sol";
 
contract Organization{
  address loansContractAddress;
  constructor() public {
 	   
  }
  
  function createLoan (address _userAddress,address loaner,uint128 _amount) public returns(bool)  {
    Loans myloans = Loans(loansContractAddress);
    //TRIGGER EVENT TO USER
    // WAIT AN EVENT COMING FROM THE USER IF IT COME ADD
    
    myloans.add(_userAddress,loaner,_amount,false);
  	return true;
  }
  function getLoanAmount () internal returns(uint128)  {
  	 
  }
  function inquiry () public{
   }
  function setLoansContractAddress(address _loansContractAddress) public {
    loansContractAddress=_loansContractAddress;
  }
  
}