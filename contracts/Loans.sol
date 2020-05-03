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
 
 
  constructor() public{
    
  }
  
  function add(address _loanReceiver,address _loaner,uint128 _loanAmount,bool _type) public {
    uint256 id = now;
    Loan memory loan = Loan(id,_loanReceiver,_loaner,_loanAmount);
     
     if (_type){
      loans.push(loan);  
     }
     else
     { 
      pendingLoans.push(loan);
     }
   }
  function searchPending(uint256 _loanId)private returns (uint256) 
  {
    for(uint256 i = 0; i<pendingLoans.length; i += 1)
    {
      if(pendingLoans[i].id == _loanId)
        return uint256(i);
    }

  }
  function confirmLoan(uint256 _loanId)public returns(bool){
   address loanie = msg.sender;
   uint256 index = searchPending(_loanId);
   if(pendingLoans[index].loanReceiver!=loanie)
   {
    return false;
   }
   Loan memory myLoan = pendingLoans[index];
   loans.push(myLoan);
   return true;
  }
  function rejectLoan(uint256 _loanId)public returns(bool){
   address loanie = msg.sender;
   uint256 index = searchPending(_loanId);
   if(pendingLoans[index].loanReceiver!=loanie)
   {
    return false;
   }
   delete  pendingLoans[index];
   return true;
  }

  //******************************************//
  function getPendingLoansLength() public returns (uint256){
    return pendingLoans.length;
  }
  function getPendingListLoanersAddresses(address _loanie) public returns (address [] memory){
    address [] memory loanersAddresses = new address [](pendingLoans.length);
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
    uint256 [] memory loansAmounts = new uint256 [](pendingLoans.length);
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