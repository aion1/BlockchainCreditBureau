pragma solidity>=0.4.21<0.7.0;
 /**
  * The Loan contract does this and that...
  */
contract Loans {

  struct Loan
  { uint256  id;
    address  loanReceiver;
    address  loaner;
    uint128  loanAmount;

//    bool     typee; // if 1 == loan else if 0 == pending loan

  }
  Loan [] loans ;
  Loan [] pendingLoans;
  //mapping (address => Loan[]) pendingLoans;
  
  uint256 pendingLoansLength;
 
  constructor() public{
    pendingLoansLength = 0;
  }
  
  function add(address _loanReceiver, address _loaner, uint128 _loanAmount,bool _type) public {
    uint256 id = now;
    Loan memory loan = Loan(id, _loanReceiver, _loaner, _loanAmount);
     
     if (_type){
      loans.push(loan);  
     }
     else
     { 
      pendingLoans.push(loan);
      pendingLoansLength += 1;
     }
   }
  function searchPending(uint256 _loanId)private view returns (int256) 
  {
    for(uint256 i = 0; i<pendingLoans.length; i += 1)
    {
      if(pendingLoans[i].id == _loanId)
        return int256(i);
    }
    return -1;
  }
  function confirmLoan(uint256 _loanId, address _loanie)public returns(bool){
    int256 intIndex = searchPending(_loanId);
    if(intIndex == -1)
      return false;

    uint256 index = uint256(intIndex);// For indexing
    if(pendingLoans[index].loanReceiver!=_loanie)
      return false;

    //Loan memory myLoan = pendingLoans[index];
    Loan memory loan = Loan(pendingLoans[index].id, pendingLoans[index].loanReceiver, pendingLoans[index].loaner, pendingLoans[index].loanAmount);
    loans.push(loan);
    delete  pendingLoans[index];
    pendingLoansLength -= 1;
    return true;

  }
  function rejectLoan(uint256 _loanId, address _loanie)public returns(bool){
    int256 intIndex = searchPending(_loanId);
    if(intIndex == -1)
      return false;

    uint256 index = uint256(intIndex);// For indexing
    if(pendingLoans[index].loanReceiver!=_loanie)
    {
      return false;
    }
    delete  pendingLoans[index];
    pendingLoansLength -= 1;
    return true;
  }

  //******************************************//
  function getPendingLoansLength() public returns (uint256){
    return pendingLoansLength;
  }
  function getPendingListLoanersAddresses(address _loanie) public returns (address [] memory){
    address [] memory loanersAddresses = new address [](pendingLoansLength);
    uint256 counter =0;

    for(uint256 i = 0; i<pendingLoans.length; i += 1)
    {
      if(pendingLoans[i].loanReceiver == _loanie)
       {
        loanersAddresses[counter]=pendingLoans[i].loaner;
        counter+=1;
       }

    }
    return loanersAddresses;
  }
  function getPendingListLoansAmounts(address _loanie) public returns (uint256 [] memory){
    uint256 [] memory loansAmounts = new uint256 [](pendingLoansLength);
    uint256 counter =0;
    for(uint256 i = 0; i<pendingLoans.length; i += 1)
    {
      if(pendingLoans[i].loanReceiver == _loanie)
       {
        loansAmounts[counter]=pendingLoans[i].loanAmount;
        counter+=1;
       }

    }
    return loansAmounts;
  }
  function getPendingListLoansIds(address _loanie) public returns (uint256 [] memory){
    uint256 [] memory loansIds = new uint256 [](pendingLoansLength);
    uint256 counter =0;
    for(uint256 i = 0; i<pendingLoans.length; i += 1)
    {
      if(pendingLoans[i].loanReceiver == _loanie)
       {
        loansIds[counter]=pendingLoans[i].id;
        counter+=1;
       }

    }
    return loansIds;
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