//pragma solidity>=0.4.21<0.7.0;
pragma experimental ABIEncoderV2;

contract Loans {

  struct Loan
  {
    uint256  id;
    address  loanReceiver;
    address  loaner;
    uint128  loanAmount;
  }
  Loan[] loans ;
  mapping (address => Loan[]) pendingLoans;
  
  uint256 pendingLoansLength;
 
  constructor() public{
    pendingLoansLength = 0;
  }
  
  function add(address _loanReceiver, address _loaner, uint128 _loanAmount, bool _type) public {
    uint256 id = now;
    Loan memory loan = Loan(id, _loanReceiver, _loaner, _loanAmount);
     
     if (_type){
      loans.push(loan);  
     }
     else
     { 
      pendingLoans[_loanReceiver].push(loan);
      pendingLoansLength += 1;
     }
   }
  function searchPending(uint256 _loanId, address _loanie)private view returns (int256) 
  {
    for(uint256 i = 0; i<pendingLoans[_loanie].length; i += 1)
    {
      if(pendingLoans[_loanie][i].id == _loanId)
        return int256(i);
    }
    return -1;
  }

  
  function confirmLoan(uint256 _loanId, address _loanie)
    public
    returns(bool)
  {
    int256 intIndex = searchPending(_loanId, _loanie);
    if(intIndex == -1)
      return false;

    uint256 index = uint256(intIndex);// For indexing
    if(pendingLoans[_loanie][index].loanReceiver!=_loanie)
      return false;

    Loans.Loan memory confimedLoan = pendingLoans[_loanie][index];
    
    loans.push(confimedLoan);
    //uint length = loans.push(pendingLoans[_loanie][index]);
    delete  pendingLoans[_loanie][index];
    pendingLoansLength -= 1;
    return true;

  }
  function rejectLoan(uint256 _loanId, address _loanie)public returns(bool){
    int256 intIndex = searchPending(_loanId, _loanie);
    if(intIndex == -1)
      return false;

    uint256 index = uint256(intIndex);// For indexing
    if(pendingLoans[_loanie][index].loanReceiver!=_loanie)
    {
      return false;
    }
    delete  pendingLoans[_loanie][index];
    pendingLoansLength -= 1;
    return true;
  }

  //******************************************//
  function getPendingLoansLength() public returns (uint256){
    return pendingLoansLength;
  }


  /*Using just one function when compiling with:
    pragma experimental ABIEncoderV2;*/
  function getPendingLoansList (address _loanie) public returns(Loan [] memory) {
    Loan [] memory myPendingLoans = new Loan [](pendingLoansLength);
    uint256 counter = 0;

    for(uint256 i = 0; i < pendingLoans[_loanie].length; i+=1){
      if(pendingLoans[_loanie][i].loanReceiver == _loanie)
      {
        myPendingLoans[counter] = pendingLoans[_loanie][i];
        counter+=1;
      }
    }
    return myPendingLoans;
  }
  
  function getLoans () public returns(Loan [] memory)  {
      return loans;
  }
  /*function getUserPendingLoans(address _loanie)public 
  {
    
    for(uint256 i = 0; i<pendingLoans.length; i += 1)
    {
      if(pendingLoans[i].loanReceiver == _loanie)
      {
         myPendingList.push(pendingLoans[i]);
      }
    }
   */


    
  
}