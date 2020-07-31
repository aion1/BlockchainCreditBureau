from CreditHistorySite.src.utility import TransactionDictionary


class UserContractPython:
    def __init__(self, userContract, web3Handler):
        self.userContract = userContract
        self.web3Handler = web3Handler

    pendingLoansEventValues = None
    eventValuesLen = 0
    loansEventValues = None
    loansEventValuesLen = 0

    def createGetPendingLoansTransaction(self, address):
        transactionDict = TransactionDictionary(300000, address, self.web3Handler.web3)
        transaction = self.userContract.functions.getPendingLoans(
        ).buildTransaction(transactionDict)
        return transaction

    def setPendingLoansEventValue(self, tx_hash):
        receipt = self.web3Handler.getTransactionReceipt(tx_hash)
        rich_logs = self.userContract.events.getAmounts().processReceipt(receipt)
        event_values = rich_logs[0]['args']

        self.pendingLoansEventValues = event_values
        self.eventValuesLen = self.getEventLength()

    def createGetLoansTransaction(self, address):
        transactionDict = TransactionDictionary(300000, address, self.web3Handler.web3)
        transaction = self.userContract.functions.getMyLoans(
        ).buildTransaction(transactionDict)
        return transaction

    def setLoansEventValues(self, tx_hash):
        receipt = self.web3Handler.getTransactionReceipt(tx_hash)
        rich_logs = self.userContract.events.getAmounts().processReceipt(receipt)
        event_values = rich_logs[0]['args']

        self.loansEventValues = event_values
        self.loansEventValuesLen = self.getLoansEventLength()

    def getEventLength(self):
        return len(self.pendingLoansEventValues['_amounts'])

    def getLoansEventLength(self):
        return len(self.loansEventValues['_amounts'])

    def validateLoan(self, loanieAddress, confirmFlag, loanId: int):
        transactionDict = TransactionDictionary(3000000, loanieAddress, self.web3Handler.web3)
        validateLoanTransaction = self.userContract.functions.validateLoan(confirmFlag, loanId). \
            buildTransaction(transactionDict)
        return validateLoanTransaction


class AccountsContractPython:
    def __init__(self, accountsContract, web3Handler):
        self.accountsContract = accountsContract
        self.web3Handler = web3Handler

    def accountExists(self, accountAddress):
        accountIndex = self.accountsContract.functions.getIndex(
            self.web3Handler.toChecksumAddress(accountAddress)).call()
        return False if accountIndex == -1 else True

    def isLoanie(self, accountIndex):
        return not self.accountsContract.functions.getType(int(accountIndex)).call()

    def getIndex(self, accountAddress):
        return self.accountsContract.functions.getIndex(self.web3Handler.toChecksumAddress(accountAddress)).call()


class OrganiztionContractPython:
    def __init__(self, organiztionContract, web3Handler):
        self.organizationContract = organiztionContract
        self.web3Handler = web3Handler

    loansEventValues = None
    loansEventValuesLen = 0

    def createLoanTransaction(self, loanieAddress, loanerAddress, amount, installmentsNum, interest):
        transactionDict = TransactionDictionary(3000000, loanerAddress, self.web3Handler.web3)
        transaction = self.organizationContract \
            .functions.createLoan(self.web3Handler.toChecksumAddress(loanieAddress), amount, installmentsNum, interest) \
            .buildTransaction(transactionDict)
        return transaction

    def createGetLoansTransaction(self, address):
        transactionDict = TransactionDictionary(300000, address, self.web3Handler.web3)
        transaction = self.organizationContract.functions.getLoans(
        ).buildTransaction(transactionDict)
        return transaction

    def setLoansEventValues(self, tx_hash):
        receipt = self.web3Handler.getTransactionReceipt(tx_hash)
        rich_logs = self.organizationContract.events.getLoanerLoans().processReceipt(receipt)
        event_values = rich_logs[0]['args']

        self.loansEventValues = event_values
        self.loansEventValuesLen = self.getLoansEventLength()

    def getLoansEventLength(self):
        return len(self.loansEventValues['_amounts'])
