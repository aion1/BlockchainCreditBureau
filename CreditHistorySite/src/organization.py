from CreditHistorySite.src.contracts import OrganiztionContractPython


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
