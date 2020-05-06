pragma solidity >=0.4.21 <0.7.0;
//pragma experimental ABIEncoderV2;
import "./Loans.sol";
contract User {
    address loansContractAddress;
    event getAmounts(uint256 [] _amounts, address [] _addresses, uint256 [] _ids);

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
        Loans myloans = Loans(loansContractAddress);
        if (_type)
          myloans.confirmLoan(_loanId, loanie);
        else
          myloans.rejectLoan(_loanId, loanie);
        return true;
    }
    function getPendingLoans() public returns(bool)
    {
        //Will get the peding loans of the user that calls the function
        address loanie = msg.sender;


        Loans myloans = Loans(loansContractAddress);
        uint256 len = myloans.getPendingLoansLength();
        address [] memory loanersAddresses = new address [](len);
        uint256 [] memory loansAmounts = new uint256 [](len);
        uint256 [] memory loansIds = new uint256 [](len);
        //Spil
        loanersAddresses = myloans.getPendingListLoanersAddresses(loanie);
        loansAmounts = myloans.getPendingListLoansAmounts(loanie);
        loansIds = myloans.getPendingListLoansIds(loanie);
        emit getAmounts(loansAmounts, loanersAddresses, loansIds);
        return true;
    }
}