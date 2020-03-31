pragma solidity >=0.4.21 <0.7.0;
import "./Loans.sol";
contract User {
  address loansContractAddress;
  constructor() public
   {

   }
  function setLoansContractAddress(address _loansContractAddress) public {
    loansContractAddress=_loansContractAddress;
  }
  function validateLoan (bool _type,uint256 _id) internal returns(bool res)  
  { 
    Loans myloans = Loans(loansContractAddress);
    if (_type ){
      myloans.confirmLoan(_id);
    }
    else
    {
      myloans.rejectLoan(_id);
    }
    return true;
  }
  function getPendingLoans() public returns (address [] memory)
  {
    address loanie = msg.sender;
    Loans myloans = Loans(loansContractAddress);
    uint256 len = myloans.getPendingLoansLength();
    address [] memory loanersAddresses = new address [](len);
    uint256 [] memory loansAmounts = new uint256 [](len);
    loanersAddresses = myloans.getPendingListLoanersAddresses(loanie);
    loansAmounts = myloans.getPendingListLoansAmounts(loanie);
    return loanersAddresses;
  }
  
  
}