from CreditHistorySite.src.contracts import UserContract, AccountsContract
from CreditHistorySite.src.utility import PendingLoan


class Web3Loanie:
    pendingLoansList = []

    def __init__(self, address, key, web3Handler, userContract: UserContract):
        self.address = address
        self.key = key
        self.web3Handler = web3Handler
        self.userContract = userContract

    def getPendingLoans(self):
        event_values = self.userContract.getPendingLoans(self.address, self.key)  # Dictionary
        return event_values

    def buildPendingLoansList(self, accountsContract: AccountsContract):
        if accountsContract.accountExists(self.address):
            index = accountsContract.getIndex(self.address)
            if accountsContract.isLoanie(index):
                self.getPendingLoans()
                values = self.userContract.pendingLoansEventValues
                for i in range(self.userContract.eventValuesLen):
                    string = ''
                    for key in values:
                        string += str(values[key][i]) + ' '
                    attributes = string.split(' ')
                    pendingLoan = PendingLoan(attributes[0], attributes[1], attributes[2], attributes[3], attributes[4])
                    self.pendingLoansList.append(pendingLoan)

            else:
                print("Either this account is not a loanie or not registered in our system.")
