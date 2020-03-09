pragma solidity >=0.4.21 <0.7.0; /**
  * The Loan contract does this and that...
  */
 contract Loan {
 	address receiver;
 	uint128 loanAmount;

   constructor() public {
     receiver = msg.receiver;
     loanAmount = Organization.getLoanAmount();
   }


 }