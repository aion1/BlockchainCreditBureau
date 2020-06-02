from CreditHistorySite.src.utility import TransactionDictionary


class Loanie:
    def __init__(self, address, key):
        self.address = address
        self.key = key

    def getPendingLoans(self, _userContract):
        transactionDict = TransactionDictionary(300000, self.address, web3)
        transaction = _userContract.functions.getPendingLoans(
        ).buildTransaction(transactionDict)
        privateKey = self.key
