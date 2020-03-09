pragma solidity >=0.4.21 <0.7.0; /**
  * The Loan contract does this and that...
  */
 contract Loan {
 	address receiver;
 	uint128 loan_amount;

   constructor() public {
     receiver = msg.receiver;
     loan_amount = Organization.getLoanAmount();
   }


 }