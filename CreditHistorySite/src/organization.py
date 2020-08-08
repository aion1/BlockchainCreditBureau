from CreditHistorySite.src.contracts import \
    OrganiztionContractPython, AccountsContractPython, LoansContractPython
from CreditHistorySite.src.utility import Loan, Installment


class Web3Organization:
    def __init__(self, address, key, web3Handler,
                 organizationContractPython: OrganiztionContractPython,
                 accountsContractPython: AccountsContractPython,
                 loansContractPython: LoansContractPython):
        self.address = address
        self.key = key
        self.web3Handler = web3Handler
        self.organizationContractPython = organizationContractPython
        self.accountsContractPython = accountsContractPython
        self.loansContractPython = loansContractPython

    def createLoan(self, loanieAddress, amount, installmentsNum, interest):
        createLoanTransaction = self.organizationContractPython. \
            createLoanTransaction(loanieAddress, self.address, amount, installmentsNum, interest)
        tx_hash = self.web3Handler.transact(createLoanTransaction, self.key)

    def buildLoansList(self):
        loansList = []
        if self.accountsContractPython.accountExists(self.address):
            index = self.accountsContractPython.getIndex(self.address)
            if not self.accountsContractPython.isLoanie(index):
                self.getLoans()
                values = self.organizationContractPython.loansEventValues
                for i in range(self.organizationContractPython.loansEventValuesLen):
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
                print("Either this account is not an organization or not registered in our system.")

        return loansList

    def getLoans(self):
        transaction = self.organizationContractPython.createGetLoansTransaction(self.address)
        tx_hash = self.web3Handler.transact(transaction, self.key)
        self.organizationContractPython.setLoansEventValues(tx_hash)

    def getInstallments(self, loanId):
        transaction = self.loansContractPython.createGetInstallmentsTransaction(self.address, loanId)
        tx_hash = self.web3Handler.transact(transaction, self.key)
        self.loansContractPython.setInstallmentsEventValues(tx_hash)

    def buildInstallmentsList(self, loanId):
        installmentsList = []
        if self.accountsContractPython.accountExists(self.address):
            index = self.accountsContractPython.getIndex(self.address)
            if not self.accountsContractPython.isLoanie(index):
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
                print("Either this account is not a loanie ")
        else:
            print("or not registered in our system.")

        return installmentsList

    def confrimInstallment(self, loanId, installmentIndex):
        createInstallmentTransaction = self.organizationContractPython \
            .createConfirmInstallmentTransaction(
            self.address,
            loanId,
            installmentIndex)
        tx_hash = self.web3Handler.transact(createInstallmentTransaction,
                                            self.key)

    def getLoanieLoans(self, loanieAddress):
        transaction = self.organizationContractPython.createGetLoanieLoansTransaction(self.address, loanieAddress)
        tx_hash = self.web3Handler.transact(transaction, self.key)
        self.organizationContractPython.setLoanieLoansEventValues(tx_hash)

    def buildLoanieLoansList(self, loanieAddress):
        loanieLoansList = []
        if self.accountsContractPython.accountExists(self.address):
            index = self.accountsContractPython.getIndex(self.address)
            if not self.accountsContractPython.isLoanie(index):
                self.getLoanieLoans(loanieAddress)
                values = self.organizationContractPython.loanieLoansEventValues
                for i in range(self.organizationContractPython.loanieLoansEventValuesLen):
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
                    loanieLoansList.append(loan)

            else:
                print("Either this account is not an organization or not registered in our system.")

        return loanieLoansList
