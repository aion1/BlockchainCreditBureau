//pragma solidity >=0.4.21 <0.7.0;
pragma experimental ABIEncoderV2;
import "./Loans.sol";
contract User {
    address loansContractAddress;
    event getAmounts(uint256 [] _amounts, address [] _addresses, uint256 [] _ids, uint128 [] _installmentsNum , uint128 [] _interest);
    event getLoans(Loans.Loan[] _loans);
   


    
    constructor() public
    {

    }
    //To set the (loans contract) address deployed on the chain
    function setLoansContractAddress(address _loansContractAddress) public {
        loansContractAddress=_loansContractAddress;
    }



    function validateLoan (bool _type, uint256 _loanId) public returns(bool res)  
    { 
        address loanie = msg.sender;
        Loans loansContract = Loans(loansContractAddress);
        if (_type)
          loansContract.confirmLoan(_loanId, loanie);
        else
          loansContract.rejectLoan(_loanId, loanie);
        return true;
    }



    function getPendingLoans() public returns(bool)
    {
        //Will get the peding loans of the user that calls the function
        address loanie = msg.sender;


        Loans loansContract = Loans(loansContractAddress);
        uint256 len = loansContract.getPendingLoansLength();
        address [] memory loanersAddresses = new address [](len);
        uint256 [] memory loansAmounts = new uint256 [](len);
        uint256 [] memory loansIds = new uint256 [](len);
        uint128 [] memory loansInstallmentsNums = new uint128 [](len);
        uint128 [] memory loansInterests = new uint128 [](len);

        Loans.Loan [] memory pendingLoans = new Loans.Loan[](len);
        pendingLoans = loansContract.getPendingLoansList(loanie); 
        for(uint256 i = 0; i < len; i += 1)
        {
          loanersAddresses[i] = pendingLoans[i].loaner;
          loansAmounts[i] = pendingLoans[i].loanAmount;
          loansIds[i] = pendingLoans[i].id;
          loansInstallmentsNums [i] = pendingLoans[i].installmentsNum;
          loansInterests[i] = pendingLoans[i].interest;
        }
        emit getAmounts(loansAmounts, loanersAddresses, loansIds, loansInstallmentsNums, loansInterests);
        //emit getLoans(pendingLoans);
        return true;
    }
    function getMyLoans() public returns(bool) {
        address loanie = msg.sender;
        Loans loansContract = Loans(loansContractAddress);
        uint256 loansLen = loansContract.uGetMyLoansLen(loanie);
        Loans.Loan [] memory loans = new Loans.Loan[](loansLen);
        loans = loansContract.uGetMyLoans(loanie);
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
        emit getAmounts(loansAmounts, loanersAddresses, loansIds, loansInstallmentsNums, loansInterests);
        return true;
    }

    function getPoints () public returns(uint256)
    {
        address loanie = msg.sender;
        
    }
    
   
    
}