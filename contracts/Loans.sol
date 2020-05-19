//pragma solidity>=0.4.21<0.7.0;
pragma experimental ABIEncoderV2;

contract Loans {

  struct  Installment{
    uint256 amount;
    uint256 payDate;
    uint256 paidOutDate;
    bool paid;
  }
  struct Loan
  {
    uint256  id;
    address  loanReceiver;
    address  loaner;
    uint128  loanAmount;
    uint128  installmentsNum;
    uint128  interest;
  }  
  mapping (address => Loan[]) pendingLoans;
  mapping (address => Loan[]) loans;
  mapping (uint256 => Installment[]) installments;

  uint256 pendingLoansLength;
 
  constructor() public{
    pendingLoansLength = 0;
  }

  function add(address _loanReceiver, address _loaner, uint128 _loanAmount, bool _type, uint128 _installmentsNum, uint128 _interest) public {
    uint256 id = now;
     Loan memory loan = Loan(id, _loanReceiver, _loaner, _loanAmount, _installmentsNum, _interest);

     if (_type){
      loans[_loanReceiver].push(loan);
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
    
    loans[_loanie].push(confimedLoan);
    //uint length = loans.push(pendingLoans[_loanie][index]);
    delete  pendingLoans[_loanie][index];
    pendingLoansLength -= 1;
    uint256 date = now;
    initializeInstallments(confimedLoan.loanAmount,confimedLoan.interest,confimedLoan.installmentsNum,confimedLoan.id,date);
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
  
 /** function getLoans () public returns(Loan [] memory)  {
      return loans;
  }
*/
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

   //u stands for user
   function uGetMyLoans (address _loanie) public returns(Loan [] memory){

    return loans[_loanie];
   }
   function uGetMyLoansLen (address _loanie) public returns(uint256) {
     
     return loans[_loanie].length;
   }
   function initializeInstallments(uint128 _loanAmount,uint128 _interest,uint128 _installmentsNum,uint256 _id,uint256 _initialDate) public returns(bool)
   {
      uint256 month =  2592000 ;  
      uint256 date = _initialDate +month;
      uint256 amount = 10000;
      //_loanAmount + _loanAmount * (_interest/100);
      uint256 installmentAmountReminder=amount % _installmentsNum;
      amount-=installmentAmountReminder;
      uint256 installmentAmount=amount/_installmentsNum;
      for(uint256 i=0; i<_installmentsNum; i+=1)
      {
        if(i==_installmentsNum-1)
        {
          installmentAmount+=installmentAmountReminder;
        }
        Installment memory installment =Installment(installmentAmount,date,0,false);
        // 0 means that the paydate is not initialized yet
        installments[_id].push(installment);
        date += month;
      }

      //installments[_id][_installmentsNum-1].amount+=installmentAmountReminder;
      return true;
   }

   function getInstallments (uint256 _id) public returns(Installment [] memory ) {
     
     return installments[_id];
   }
   function getInstallmentsLen (uint256 _id) public returns(uint256) {
     
     return installments[_id].length;
   }
}