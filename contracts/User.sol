//pragma solidity >=0.4.21 <0.7.0;
pragma experimental ABIEncoderV2;
import "./Loans.sol";
contract User {
    address loansContractAddress;
    event getAmounts(uint256 [] _amounts, address [] _addresses, uint256 [] _ids, uint128 [] _installmentsNum , uint128 [] _interest);
    event getLoans(Loans.Loan[] _loans);
    event getInstallments(uint256 []_amount,uint256 []_payDate,uint256 []_payOutDate,bool []_paid);


    
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
    function getMyInstallments (uint256 _id) public returns(bool res){
        address loanie = msg.sender;
        Loans loansContract = Loans(loansContractAddress);
        uint256 installmentsLen = loansContract.getInstallmentsLen(_id);
        //uint256 loansLen = loansContract.getInstallments(_id);
        Loans.Installment [] memory installments = new Loans.Installment[](installmentsLen);
        installments = loansContract.getInstallments(_id);
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
        emit getInstallments(installmentAmounts, payDates, payOutDate, paids);
        return true;
    }
    
}