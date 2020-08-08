//pragma solidity >=0.4.21 <0.7.0;
pragma experimental ABIEncoderV2;
import "./Loans.sol";
contract User {

    event getAmounts(uint256 [] _amounts, address [] _addresses, address [] _loaniesAddresses, uint256 [] _ids, uint128 [] _installmentsNum , uint128 [] _interest);
    event getLoans(Loans.Loan[] _loans);
   	event delegateCall(bool success);


    
    constructor() public
    {

    }
    address sender;
    address loansContractAddress;
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


    function emitLoans(Loans.Loan [] memory _loans, uint256 _len ) internal returns(bool res)  {
        
        address [] memory loanersAddresses = new address [](_len);
        uint256 [] memory loansAmounts = new uint256 [](_len);
        uint256 [] memory loansIds = new uint256 [](_len);
        uint128 [] memory loansInstallmentsNums = new uint128 [](_len);
        uint128 [] memory loansInterests = new uint128 [](_len);
        address [] memory loaniesAddresses = new address [](_len);



        for(uint256 i = 0; i < _len; i += 1)
        {
          loanersAddresses[i] = _loans[i].loaner;
          loansAmounts[i] = _loans[i].loanAmount;
          loansIds[i] = _loans[i].id;
          loansInstallmentsNums [i] = _loans[i].installmentsNum;
          loansInterests[i] = _loans[i].interest;
          loaniesAddresses[i] = _loans[i].loanReceiver;
        }
        emit getAmounts(loansAmounts, loanersAddresses, loaniesAddresses, loansIds, loansInstallmentsNums, loansInterests);
    }
    



    function getPendingLoans() public returns(bool)
    {
        //Will get the peding loans of the user that calls the function
        address loanie = msg.sender;


        Loans loansContract = Loans(loansContractAddress);
        uint256 len = loansContract.getPendingLoansLength();
        Loans.Loan [] memory pendingLoans = new Loans.Loan[](len);
        pendingLoans = loansContract.getPendingLoansList(); 

        emitLoans(pendingLoans, len);

        //emit getLoans(pendingLoans);
        return true;
    }
    function getMyLoans() public returns(bool) {
        address loanie = msg.sender;
        Loans loansContract = Loans(loansContractAddress);
        uint256 loansLen = loansContract.uGetMyLoansLen(loanie);
        Loans.Loan [] memory loans = new Loans.Loan[](loansLen);



        loans = loansContract.uGetMyLoans();

        emitLoans(loans, loansLen);
        return true;
    }

    function getPoints () public returns(uint256)
    {
        address loanie = msg.sender;
        
    }
    
   
    
}