from CreditHistorySite.src.contracts import UserContractPython, AccountsContractPython
from CreditHistorySite.src.utility import Loan


class Web3Loanie:

    def __init__(self, address, key, web3Handler, userContractPython: UserContractPython):
        self.address = address
        self.key = key
        self.web3Handler = web3Handler
        self.userContractPython = userContractPython

    def getPendingLoans(self):
        transaction = self.userContractPython.createGetPendingLoansTransaction(self.address)
        tx_hash = self.web3Handler.transact(transaction, self.key)
        self.userContractPython.setPendingLoansEventValue(tx_hash)

    def getLoans(self):
        transaction = self.userContractPython.createGetLoansTransaction(self.address)
        tx_hash = self.web3Handler.transact(transaction, self.key)
        self.userContractPython.setLoansEventValues(tx_hash)

    def buildPendingLoansList(self, accountsContract: AccountsContractPython):
        pendingLoansList = []
        if accountsContract.accountExists(self.address):
            index = accountsContract.getIndex(self.address)
            if accountsContract.isLoanie(index):
                self.getPendingLoans()
                values = self.userContractPython.pendingLoansEventValues
                for i in range(self.userContractPython.eventValuesLen):
                    string = ''
                    for key in values:
                        string += str(values[key][i]) + ' '
                    attributes = string.split(' ')
                    pendingLoan = Loan(attributes[0], attributes[1], attributes[2], attributes[3], attributes[4])
                    pendingLoansList.append(pendingLoan)

            else:
                print("Either this account is not a loanie or not registered in our system.")

        return pendingLoansList

    def buildLoansList(self, accountsContract: AccountsContractPython):
        loansList = []
        if accountsContract.accountExists(self.address):
            index = accountsContract.getIndex(self.address)
            if accountsContract.isLoanie(index):
                self.getLoans()
                values = self.userContractPython.loansEventValues
                for i in range(self.userContractPython.loansEventValuesLen):
                    string = ''
                    for key in values:
                        string += str(values[key][i]) + ' '
                    attributes = string.split(' ')
                    loan = Loan(attributes[0], attributes[1], attributes[2], attributes[3], attributes[4])
                    loansList.append(loan)

            else:
                print("Either this account is not a loanie or not registered in our system.")

        return loansList

    def confirmPendingLoan(self, loanId: int):
        confrimTransaction = self.userContractPython.validateLoan(self.address, True, loanId)
        tx_hash = self.web3Handler.transact(confrimTransaction, self.key)

    def rejectPendingLoan(self, loanId: int):
        rejectTransaction = self.userContractPython.validateLoan(self.address, False, loanId)
        tx_hash = self.web3Handler.transact(rejectTransaction, self.key)
