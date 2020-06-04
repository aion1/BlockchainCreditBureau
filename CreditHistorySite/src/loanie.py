from CreditHistorySite.src.contracts import UserContract, AccountsContract


class Loanie:
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
            if accountsContract.isLoanie(self.address):
                self.getPendingLoans()
                values = self.userContract.pendingLoansEventValues
                for i in range(self.userContract.eventValuesLen):
                    string = ''
                    for key in values:
                        string += str(values[key][i]) + ' '
                    self.pendingLoansList.append(string)

            else:
                print("Either this account is not a loanie or not registered in our system.")
