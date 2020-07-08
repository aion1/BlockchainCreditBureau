from CreditHistorySite.src.utility import TransactionDictionary


class UserContractPython:
    def __init__(self, userContract, web3Handler):
        self.userContract = userContract
        self.web3Handler = web3Handler

    pendingLoansEventValues = None
    eventValuesLen = 0

    def getPendingLoans(self, address, key):
        transactionDict = TransactionDictionary(300000, address, self.web3Handler.web3)
        transaction = self.userContract.functions.getPendingLoans(
        ).buildTransaction(transactionDict)
        transaction_hash = self.web3Handler.transact(transaction, key)
        receipt = self.web3Handler.getTransactionReceipt(transaction_hash)
        rich_logs = self.userContract.events.getAmounts().processReceipt(receipt)
        event_values = rich_logs[0]['args']

        self.pendingLoansEventValues = event_values
        self.eventValuesLen = self.getEventLength()

    def getEventLength(self):
        return len(self.pendingLoansEventValues['_amounts'])


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
