pragma solidity >=0.4.21 <0.7.0; /**
  * The Loan contract does this and that...
  */
contract Loans {

  struct Loan
  {
    address  loanReceiver;
    address  loaner;
    uint128  loanAmount;
  }
  Loan [] loans ;
  constructor() public{
    
  }
  function add(address _loanReceiver,address _loaner,uint128 _loanAmount) public {
     Loan memory loan = Loan(_loanReceiver,_loaner,_loanAmount);
     loans.push(loan);
  }
}