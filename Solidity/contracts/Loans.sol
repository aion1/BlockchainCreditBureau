//pragma solidity>=0.4.21<0.7.0;
pragma experimental ABIEncoderV2;

import "./Accounts.sol";

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
    uint256  loanAmount;
    uint128  installmentsNum;
    uint128  interest;
  }  

  mapping (uint256 => Loan) allLoans;
  

  address accountsContractAddress;
  //This should be refactored to something more memory-efficient
  mapping (address => Loan[]) pendingLoans;
  mapping (address => uint256[]) loans;
  mapping (uint256 => Installment[]) installments;
  mapping (address => uint256[]) loanerLoans;

  //To set the (loans contract) address deployed on the chain
  function setAccountsContractAddress(address _accountsContractAddress) public
  {
    accountsContractAddress=_accountsContractAddress;
  }

  uint256 pendingLoansLength;
 
  constructor() public{
    pendingLoansLength = 0;
  }
  event getLoanInstallments(uint256 []_amount,uint256 []_payDate,uint256 []_payOutDate,bool []_paid);
  
  function add(address _loanReceiver, address _loaner, uint256 _loanAmount, bool _type, uint128 _installmentsNum, uint128 _interest) public {
    uint256 id = now;
     Loan memory loan = Loan(id, _loanReceiver, _loaner, _loanAmount, _installmentsNum, _interest);

     if (_type){
      loans[_loanReceiver].push(id);
      loanerLoans[_loaner].push(id);
      allLoans[id] = loan;
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
    address _loaner = confimedLoan.loaner;
    loans[_loanie].push(confimedLoan.id);
    loanerLoans[_loaner].push(confimedLoan.id);
    allLoans[confimedLoan.id] = confimedLoan;
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
  function getPendingLoansList () public returns(Loan [] memory) {
  	//address _loanie = msg.sender;
    address _loanie=tx.origin;

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


  function getLoanerLoans()public returns (Loan [] memory)
  {

    address _loaner=tx.origin;

    Loan [] memory myLoanerLoans = new Loan [](loanerLoans[_loaner].length);
    for(uint256 i=0; i < loanerLoans[_loaner].length; i+=1)
    {
      uint256 loanId = loanerLoans[_loaner][i];
      myLoanerLoans[i] = allLoans[loanId];
    }


    return myLoanerLoans;
  }



  function getLoanerLoansLen(address _loaner)public returns (uint256 )
  {
    return loanerLoans[_loaner].length;
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
   function uGetMyLoans () public returns(Loan [] memory){

    address _loanie = tx.origin;
    
    
    Loan [] memory myLoans = new Loan [](loans[_loanie].length);
    for(uint256 i=0; i < loans[_loanie].length; i+=1)
    {
      uint256 loanId = loans[_loanie][i];
      myLoans[i] = allLoans[loanId];
    }
    return myLoans;
   }

   function uGetMyLoansLen (address _loanie) public returns(uint256) {
     
     return loans[_loanie].length;
   }
   function initializeInstallments(uint256 _loanAmount,uint128 _interest,uint128 _installmentsNum,uint256 _id,uint256 _initialDate) public returns(bool)
   {
      uint256 month =  2592000 ;  
      uint256 date = _initialDate +month;
     
      //_loanAmount + _loanAmount * (_interest/100);
      uint256 installmentAmountReminder=_loanAmount % _installmentsNum;
      _loanAmount-=installmentAmountReminder;
      uint256 installmentAmount=_loanAmount/_installmentsNum;
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
  function getMyInstallments (uint256 _id) public returns(bool res)
  {
    address loanie = msg.sender;
    
    uint256 installmentsLen = getInstallmentsLen(_id);
    //uint256 loansLen = loansContract.getInstallments(_id);
    Installment [] memory installments = new Installment[](installmentsLen);
    installments = getInstallments(_id);
    uint256 [] memory installmentAmounts = new uint256 [](installmentsLen);
    uint256 [] memory payDates = new uint256 [](installmentsLen);
    uint256 [] memory payOutDate = new uint256 [](installmentsLen);
    bool [] memory paids = new bool [](installmentsLen);
    for(uint256 i = 0; i < installmentsLen; i += 1)
    {
        installmentAmounts[i] = installments[i].amount;
        payDates[i] = installments[i].payDate;
        payOutDate[i] = installments[i].paidOutDate;
        paids[i] = installments[i].paid;
    }
    emit getLoanInstallments(installmentAmounts, payDates, payOutDate, paids);
    return true;
  }
  function confirmLoanInstallment(address loaner,uint256 _index,uint256 _id) public returns (bool)
  {
    if(installments[_id][_index].paid==true)
    {
      return false;
    }
    installments[_id][_index].paid=true;
    installments[_id][_index].paidOutDate=now;


    Loan memory currentLoan = allLoans[_id];
    

    address loanie=currentLoan.loanReceiver;
    uint256 month =  2592000 ;
    uint256 week=604800;
    uint256 points=5;
    uint256 day=86400;

    // (week*3) and month will be removed
    uint256 differanceTime=(installments[_id][_index].paidOutDate+month+(week*4))-installments[_id][_index].payDate;


    if(differanceTime<=day) // pay in the same day
    {
      setNewPoints(loanie,points);
    }
    else if(differanceTime<=week)
    {
      points-=1;
      setNewPoints(loanie,points);
    }
    else
    {
      for(uint256 i=1;week<differanceTime;i+=1)
      {
        if(week*i>differanceTime)
        {
          break;
        }
        if(points==0)
        {
          break;
        }
        points-=1;
      } 
      setNewPoints(loanie,points);
    }
    return true;
  } 
  function setNewPoints (address _loanie,uint256 _points) public returns(bool res)  
  {
    Accounts accountsContract = Accounts(accountsContractAddress);
    accountsContract.changePoints(_loanie,_points);
    return true;
  }
  
}