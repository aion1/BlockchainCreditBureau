from CreditHistorySite.src.contracts import OrganiztionContractPython, AccountsContractPython
from CreditHistorySite.src.utility import Loan


class Web3Organization:
    def __init__(self, address, key, web3Handler, organizationContractPython: OrganiztionContractPython):
        self.address = address
        self.key = key
        self.web3Handler = web3Handler
        self.organizationContractPython = organizationContractPython

    def createLoan(self, loanieAddress, amount, installmentsNum, interest):
        createLoanTransaction = self.organizationContractPython. \
            createLoanTransaction(loanieAddress, self.address, amount, installmentsNum, interest)
        tx_hash = self.web3Handler.transact(createLoanTransaction, self.key)

    def buildLoansList(self, accountsContractPython: AccountsContractPython):
        loansList = []
        if accountsContractPython.accountExists(self.address):
            index = accountsContractPython.getIndex(self.address)
            if not accountsContractPython.isLoanie(index):
                self.getLoans()
                values = self.organizationContractPython.loansEventValues
                for i in range(self.organizationContractPython.loansEventValuesLen):
                    string = ''
                    for key in values:
                        string += str(values[key][i]) + ' '
                    attributes = string.split(' ')
                    loan = Loan(attributes[0], attributes[1], attributes[2], attributes[3], attributes[4])
                    loansList.append(loan)

            else:
                print("Either this account is not an organization or not registered in our system.")

        return loansList

    def getLoans(self):
        transaction = self.organizationContractPython.createGetLoansTransaction(self.address)
        tx_hash = self.web3Handler.transact(transaction, self.key)
        self.organizationContractPython.setLoansEventValues(tx_hash)
