pragma experimental ABIEncoderV2;
pragma solidity >=0.4.21 <0.7.0;

/**
 * The contractName contract does this and that...
 */


import "./Loans.sol";
 
contract Organization{
  address loansContractAddress;
  address loanerAddress;
  constructor() public {
 	   
  }
   event getLoanerLoans(uint256 [] _amounts, address [] _addresses, uint256 [] _ids, uint128 [] _installmentsNum , uint128 [] _interest);
  function createLoan (address _loanie, uint256 _amount, uint128 _installmentsNum, uint128 _interest) public returns(bool)  {
    address loaner = msg.sender;
    loanerAddress = loaner;
    Loans loansContract = Loans(loansContractAddress);
    
    //TRIGGER EVENT TO USER
    // WAIT AN EVENT COMING FROM THE USER IF IT COME ADD
    
    loansContract.add(_loanie, loaner, _amount, false, _installmentsNum, _interest);
  	return true;
  }
  function getLoans()public returns(bool) 
  {
    address loaner = msg.sender;
    Loans loansContract = Loans(loansContractAddress);
    uint256 loansLen = loansContract.getLoanerLoansLen();
    Loans.Loan [] memory loans = new Loans.Loan[](loansLen);
    loans=loansContract.getLoanerLoans();
    address [] memory loanersAddresses = new address [](loansLen);
    uint256 [] memory loansAmounts = new uint256 [](loansLen);
    uint256 [] memory loansIds = new uint256 [](loansLen);
    uint128 [] memory loansInstallmentsNums = new uint128 [](loansLen);
    uint128 [] memory loansInterests = new uint128 [](loansLen);
    for(uint256 i = 0; i < loansLen; i += 1)
    {
        loanersAddresses[i] = loans[i].loaner;
        loansAmounts[i] = loans[i].loanAmount;
        loansIds[i] = loans[i].id;
        loansInstallmentsNums [i] = loans[i].installmentsNum;
        loansInterests[i] = loans[i].interest;
    }
    emit getLoanerLoans(loansAmounts, loanersAddresses, loansIds, loansInstallmentsNums, loansInterests);
    return true;
  }
 
  //To set the (loans contract) address deployed on the chain
  //It should be set before deploying, but will be updated later
  function setLoansContractAddress(address _loansContractAddress) public {
    loansContractAddress=_loansContractAddress;
  }
  function confirmInstallment(uint256 _index,uint256 _id)public returns(bool)
  {
    address loaner=msg.sender;
    Loans loansContract = Loans(loansContractAddress);
    bool result =loansContract.confirmLoanInstallment(loaner,_index,_id);
    return result;

  }
}