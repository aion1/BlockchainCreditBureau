from CreditHistorySite.src.contracts import UserContractPython, AccountsContractPython, LoansContractPython
from CreditHistorySite.src.utility import Loan, Installment


class Web3Loanie:

    def __init__(self, address, key, web3Handler,
                 userContractPython: UserContractPython,
                 accountsContractPython: AccountsContractPython,
                 loansContractPython: LoansContractPython):

        self.address = address
        self.key = key
        self.web3Handler = web3Handler
        self.userContractPython = userContractPython
        self.accountsContractPython = accountsContractPython
        self.loansContractPython = loansContractPython

    def getPendingLoans(self):
        transaction = self.userContractPython.createGetPendingLoansTransaction(self.address)
        tx_hash = self.web3Handler.transact(transaction, self.key)
        self.userContractPython.setPendingLoansEventValue(tx_hash)

    def buildPendingLoansList(self):
        pendingLoansList = []
        if self.accountsContractPython.accountExists(self.address):
            index = self.accountsContractPython.getIndex(self.address)
            if self.accountsContractPython.isLoanie(index):
                self.getPendingLoans()
                values = self.userContractPython.pendingLoansEventValues
                for i in range(self.userContractPython.eventValuesLen):
                    string = ''
                    for key in values:
                        string += str(values[key][i]) + ' '
                    attributes = string.split(' ')
                    pendingLoan = Loan(attributes[0],
                                       attributes[1],
                                       attributes[2],
                                       attributes[3],
                                       attributes[4],
                                       attributes[5],
                                       None)
                    pendingLoansList.append(pendingLoan)

            else:
                print("Either this account is not a loanie or not registered in our system.")

        return pendingLoansList

    def getLoans(self):
        transaction = self.userContractPython.createGetLoansTransaction(self.address)
        tx_hash = self.web3Handler.transact(transaction, self.key)
        self.userContractPython.setLoansEventValues(tx_hash)

    def buildLoansList(self):
        loansList = []
        if self.accountsContractPython.accountExists(self.address):
            index = self.accountsContractPython.getIndex(self.address)
            if self.accountsContractPython.isLoanie(index):
                self.getLoans()
                values = self.userContractPython.loansEventValues
                for i in range(self.userContractPython.loansEventValuesLen):
                    string = ''
                    for key in values:
                        string += str(values[key][i]) + ' '
                    attributes = string.split(' ')
                    loanId = int(attributes[3])
                    loan = Loan(attributes[0],
                                attributes[1],
                                attributes[2],
                                attributes[3],
                                attributes[4],
                                attributes[5],
                                self.buildInstallmentsList(loanId))
                    loansList.append(loan)

            else:
                print("Either this account is not a loanie or not registered in our system.")

        return loansList

    def getInstallments(self, loanId):
        transaction = self.loansContractPython.createGetInstallmentsTransaction(self.address, loanId)
        tx_hash = self.web3Handler.transact(transaction, self.key)
        self.loansContractPython.setInstallmentsEventValues(tx_hash)

    def buildInstallmentsList(self, loanId):
        installmentsList = []
        if self.accountsContractPython.accountExists(self.address):
            index = self.accountsContractPython.getIndex(self.address)
            if self.accountsContractPython.isLoanie(index):
                self.getInstallments(loanId)
                values = self.loansContractPython.installmentsEventValues
                for i in range(self.loansContractPython.installmentsEventValuesLen):
                    string = ''
                    for key in values:
                        string += str(values[key][i]) + ' '
                    attributes = string.split(' ')
                    loan = Installment(attributes[0],
                                       attributes[1],
                                       attributes[2],
                                       attributes[3])
                    installmentsList.append(loan)

            else:
                print("Either this account is not a loanie or not registered in our system.")

        return installmentsList

    def confirmPendingLoan(self, loanId: int):
        confrimTransaction = self.userContractPython.validateLoan(self.address, True, loanId)
        tx_hash = self.web3Handler.transact(confrimTransaction, self.key)

    def rejectPendingLoan(self, loanId: int):
        rejectTransaction = self.userContractPython.validateLoan(self.address, False, loanId)
        tx_hash = self.web3Handler.transact(rejectTransaction, self.key)
