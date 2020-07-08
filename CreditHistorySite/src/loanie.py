from CreditHistorySite.src.contracts import UserContractPython, AccountsContractPython
from CreditHistorySite.src.utility import PendingLoan


class Web3Loanie:
    pendingLoansList = []

    def __init__(self, address, key, web3Handler, userContractPython: UserContractPython):
        self.address = address
        self.key = key
        self.web3Handler = web3Handler
        self.userContractPython = userContractPython

    def getPendingLoans(self):
        self.userContractPython.getPendingLoans(self.address, self.key)  # Dictionary

    def buildPendingLoansList(self, accountsContract: AccountsContractPython):
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
                    pendingLoan = PendingLoan(attributes[0], attributes[1], attributes[2], attributes[3], attributes[4])
                    self.pendingLoansList.append(pendingLoan)

            else:
                print("Either this account is not a loanie or not registered in our system.")
