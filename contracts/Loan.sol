pragma solidity >=0.4.21 <0.7.0; /**
  * The Loan contract does this and that...
  */
 contract Loan {
 	address loanReceiver;
 	uint128 loanAmount;

   constructor() public {
     //loanReceiver = msg.receiver; //No attribute receiver in msg object!
     //loanAmount = Organization.getLoanAmount();
   }


 }