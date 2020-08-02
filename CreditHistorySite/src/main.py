# coding: utf-8

# In[1]:


from web3 import Web3
from getpass import getpass
import random

from CreditHistorySite.src.contracts import \
    UserContractPython, AccountsContractPython, OrganiztionContractPython, LoansContractPython
from CreditHistorySite.src.utility import \
    Web3Handler, TransactionDictionary, AccountsHandler

# In[2]:

ganache_url = "HTTP://127.0.0.1:7545"
web3Handler = Web3Handler(ganache_url)
web3 = Web3(Web3.HTTPProvider(ganache_url))
# This is our main account that controls everything
web3.eth.defaultAccount = web3.eth.accounts[0]

# In[3]:

# Get contracts from Ganache
organizationContract = web3Handler.getContract('Organization.json')
userContract = web3Handler.getContract('User.json')
accountsConract = web3Handler.getContract('Accounts.json')
loansContract = web3Handler.getContract('Loans.json')

# In[4]:
loansContractAddress = web3Handler.getContractAddress('Loans.json')
accountsContractAdd = web3Handler.getContractAddress('Accounts.json')

# This should be changed to be a more robus way. We can give the loansContractAddress using the constructor
# but this has problems when doing this in the 2_deploy_contracts.js
transaction = organizationContract.functions.setLoansContractAddress(loansContractAddress). \
    buildTransaction(TransactionDictionary(300000, web3Handler.web3.eth.defaultAccount, web3Handler.web3))
transaction_hash = web3Handler.transact(transaction, web3Handler.defaultKey)
userContract.functions.setLoansContractAddress(loansContractAddress).transact()
loansContract.functions.setAccountsContractAddress(accountsContractAdd).transact()
"""
HERE SHOULD BE THE END OF MAIN FUNCTIONS THAT RUN WHENEVER THE SERVER IS UP
"""

# In[5]:

accsHandler = AccountsHandler(web3Handler, accountsConract)
userContractPython = UserContractPython(userContract, web3Handler)
accountsContractPython = AccountsContractPython(accountsConract, web3Handler)
organizationContractPython = OrganiztionContractPython(organizationContract, web3Handler)
loansContractPython = LoansContractPython(loansContract, web3Handler)

'''
# In[6]:


def deleteUser():
    accountsConract.functions.deleteAccount(web3.eth.accounts[1]).transact()


def createLoan(_loanie, _loaner, _amount, _organizationContract, _installmentsNum, _interest):
    transaction = _organizationContract.functions.createLoan(_loanie, _amount, _installmentsNum, _interest
                                                             ).buildTransaction({
        'gas': 3000000,
        'gasPrice': web3.toWei('1', 'gwei'),
        'from': _loaner,
        'nonce': web3.eth.getTransactionCount(_loaner)
    })
    _privateKey = getpass("Enter the password of the organization: ")
    signed_txn = web3.eth.account.signTransaction(transaction, private_key=_privateKey)
    transaction_hash = web3.eth.sendRawTransaction(web3.toHex(signed_txn.rawTransaction))

    # _organizationContract.functions.createLoan(_loanie, _loaner, _amount).transact()
    return True


# In[99]:


deleteUser()


# In[7]:


def getPendingLoans(_userContract, _loanieAddress, _privateKey):
    transaction = _userContract.functions.getPendingLoans(
    ).buildTransaction({
        'gas': 300000,
        'gasPrice': web3.toWei('1', 'gwei'),
        'from': _loanieAddress,
        'nonce': web3.eth.getTransactionCount(_loanieAddress)
    })

    signed_txn = web3.eth.account.signTransaction(transaction, private_key=_privateKey)
    transaction_hash = web3.eth.sendRawTransaction(web3.toHex(signed_txn.rawTransaction))
    receipt = web3.eth.getTransactionReceipt(transaction_hash)
    rich_logs = _userContract.events.getAmounts().processReceipt(receipt)
    event_values = rich_logs[0]['args']  # Dictionary
    return event_values


# In[8]:


# Suppose bank wants to create a loan
# loaner = input("Enter the loaner addrses: ")
loaner = web3.eth.accounts[5]
loaner
### Check to see whether it is a user or organization address
loanerIndex = accountsConract.functions.getIndex(loaner).call()

# In[9]:


# loanie = input("Enter the loanie address: ")
loanie = web3.eth.accounts[2]
loanie
loanieIndex = accountsConract.functions.getIndex(loanie).call()


# ## Get pending loans

# In[10]:


# Get pending loans using 3 separate functions
def getPendingLoansList(_accountIndex, _userContract, _accountsContract, _loanieAddress):
    pendingLoans = []  # 'amount loanerAddress id'
    if _accountIndex != -1:
        loanieType = _accountsContract.functions.getType(_accountIndex).call()
        if not loanieType:
            privateKey = getpass("Enter your password: ")
            values = getPendingLoans(_userContract, _loanieAddress, privateKey)
            for i in range(len(values['_amounts'])):
                string = ''
                for key in values:
                    string += str(values[key][i]) + ' '
                pendingLoans.append(string)
    else:
        print("This account is not registered in our system.")
    return pendingLoans


# In[12]:


getPendingLoansList(loanieIndex, userContract, accountsConract, loanie)

# ## Confirm or reject loans

# In[13]:


# Confirm or reject loans
pendingLoans = getPendingLoansList(loanieIndex, userContract, accountsConract, loanie)
private_key = getpass('Enter your loanie password: ')
for pendingLoan in pendingLoans:
    print('for id: ' + pendingLoan.split(' ')[0])
    loanId = pendingLoan.split(' ')[2]
    choice = input('c/r?')
    if choice == 'c':
        transaction = userContract.functions.validateLoan(True,
                                                          int(loanId)).buildTransaction({
            'gas': 1200000,
            'gasPrice': web3.toWei('1', 'gwei'),
            'from': loanie,
            'nonce': web3.eth.getTransactionCount(loanie)
        })
        signed_txn = web3.eth.account.signTransaction(transaction, private_key=private_key)
        transaction_hash = web3.eth.sendRawTransaction(web3.toHex(signed_txn.rawTransaction))
    elif choice == 'r':
        transaction = userContract.functions.validateLoan(False,
                                                          int(loanId)).buildTransaction({
            'gas': 300000,
            'gasPrice': web3.toWei('1', 'gwei'),
            'from': loanie,
            'nonce': web3.eth.getTransactionCount(loanie)
        })
        signed_txn = web3.eth.account.signTransaction(transaction, private_key=private_key)
        transaction_hash = web3.eth.sendRawTransaction(web3.toHex(signed_txn.rawTransaction))
    else:
        print("Not recognized operation.")

# # Create a new loan

# In[11]:


loaner
# Create a new loan
if loanerIndex != -1:
    loanerType = accountsConract.functions.getType(loanerIndex).call()
    if loanerType:
        # We will change this to inputs later
        amount = random.randint(1000, 1000000)
        if amount % 2 != 0:
            amount += 1
        installmentsNum = random.randint(6, 15)
        interest = random.randint(5, 35)
        amount += (amount * interest) // 100
        if createLoan(_loanie=web3.eth.accounts[2], _loaner=loaner, _amount=amount,
                      _organizationContract=organizationContract, _installmentsNum=installmentsNum, _interest=interest):
            print("Loan created")
else:
    print("This account is not registered in our system.")


# ## Get user loans

# In[56]:


def getLoans(_userContract, _loanieAddress, _privateKey):
    transaction = _userContract.functions.getMyLoans(
    ).buildTransaction({
        'gas': 70000,
        'gasPrice': web3.toWei('1', 'gwei'),
        'from': _loanieAddress,
        'nonce': web3.eth.getTransactionCount(_loanieAddress)
    })

    signed_txn = web3.eth.account.signTransaction(transaction, private_key=_privateKey)
    transaction_hash = web3.eth.sendRawTransaction(web3.toHex(signed_txn.rawTransaction))
    receipt = web3.eth.getTransactionReceipt(transaction_hash)
    rich_logs = _userContract.events.getAmounts().processReceipt(receipt)
    event_values = rich_logs[0]['args']  # Dictionary
    return event_values


# In[57]:


def getLoansList(_accountIndex, _userContract, _accountsContract, _loanieAddress):
    loans = []  # 'amount loanerAddress id'
    if _accountIndex != -1:
        loanieType = _accountsContract.functions.getType(_accountIndex).call()
        if not loanieType:
            privateKey = getpass("Enter your password: ")
            values = getLoans(_userContract, _loanieAddress, privateKey)
            for i in range(len(values['_amounts'])):
                string = ''
                for key in values:
                    string += str(values[key][i]) + ' '
                loans.append(string)
    else:
        print("This account is not registered in our system.")
    return loans


# In[58]:


getLoansList(loanieIndex, userContract, accountsConract, loanie)


# In[59]:


def getInstallments(_loanContract, _loanieAddress, _privateKey):
    myId = 1590932820
    transaction = _loanContract.functions.getMyInstallments(myId
                                                            ).buildTransaction({
        'gas': 300000,
        'gasPrice': web3.toWei('1', 'gwei'),
        'from': _loanieAddress,
        'nonce': web3.eth.getTransactionCount(_loanieAddress)
    })

    signed_txn = web3.eth.account.signTransaction(transaction, private_key=_privateKey)
    transaction_hash = web3.eth.sendRawTransaction(web3.toHex(signed_txn.rawTransaction))
    receipt = web3.eth.getTransactionReceipt(transaction_hash)
    rich_logs = _loanContract.events.getLoanInstallments().processReceipt(receipt)
    event_values = rich_logs[0]['args']  # Dictionary
    return event_values


# In[60]:


def getinstallmentsList(_accountIndex, _loanContract, _accountsContract, _loanieAddress):
    pendingLoans = []  # 'amount loanerAddress id'
    if _accountIndex != -1:
        loanieType = _accountsContract.functions.getType(_accountIndex).call()
        if not loanieType:
            privateKey = getpass("Enter your password: ")
            values = getInstallments(_loanContract, _loanieAddress, privateKey)
            for i in range(len(values['_amount'])):
                string = ''
                for key in values:
                    string += str(values[key][i]) + ' '
                pendingLoans.append(string)
    else:
        print("This account is not registered in our system.")
    return pendingLoans


# In[61]:


getinstallmentsList(loanieIndex, loansContract, accountsConract, loanie)


# ## Get Organization Loans

# In[62]:


def getLoanerLoans(_organizationContract, _loanerAddress, _privateKey):
    transaction = _organizationContract.functions.getLoans(
    ).buildTransaction({
        'gas': 70000,
        'gasPrice': web3.toWei('1', 'gwei'),
        'from': _loanerAddress,
        'nonce': web3.eth.getTransactionCount(_loanerAddress)
    })

    signed_txn = web3.eth.account.signTransaction(transaction, private_key=_privateKey)
    transaction_hash = web3.eth.sendRawTransaction(web3.toHex(signed_txn.rawTransaction))
    receipt = web3.eth.getTransactionReceipt(transaction_hash)
    rich_logs = _organizationContract.events.getLoanerLoans().processReceipt(receipt)
    event_values = rich_logs[0]['args']  # Dictionary
    return event_values


# In[63]:


def getLoanerLoansList(_accountIndex, _organizationContract, _accountsContract, _loanerAddress):
    loans = []  # 'amount loanerAddress id'
    if _accountIndex != -1:
        loanieType = _accountsContract.functions.getType(_accountIndex).call()
        if loanieType:
            privateKey = getpass("Enter your password: ")
            values = getLoanerLoans(_organizationContract, _loanerAddress, privateKey)
            for i in range(len(values['_amounts'])):
                string = ''
                for key in values:
                    string += str(values[key][i]) + ' '
                loans.append(string)
    else:
        print("This account is not registered in our system.")
    return loans


# In[64]:


getLoanerLoansList(loanerIndex, organizationContract, accountsConract, loaner)


# ## Get installment for the orgianization

# In[65]:


def getLoanerInstallmentsList(_accountIndex, _loanContract, _accountsContract, _loanerAddress):
    pendingLoans = []  # 'amount loanerAddress id'
    if _accountIndex != -1:
        loanieType = _accountsContract.functions.getType(_accountIndex).call()
        if loanieType:
            privateKey = getpass("Enter your password: ")
            values = getInstallments(_loanContract, _loanerAddress, privateKey)
            for i in range(len(values['_amount'])):
                string = ''
                for key in values:
                    string += str(values[key][i]) + ' '
                pendingLoans.append(string)
    else:
        print("This account is not registered in our system.")
    return pendingLoans


# In[66]:


getLoanerInstallmentsList(loanerIndex, loansContract, accountsConract, loaner)


# ## Confirm paid installment

# In[67]:


def confirmInstallment(_loanerIndex, _loansContract, _organizationContract, _loaner, _accountsConract):
    installments = getLoanerInstallmentsList(_loanerIndex, _loansContract, _accountsConract, _loaner)
    print(installments)
    choice = input("enter the index of installment")
    if int(choice) >= len(installments):
        print("wrong index")
        return
    myid = 1590932820
    transaction = _organizationContract.functions.confirmInstallment(int(choice), myid
                                                                     ).buildTransaction({
        'gas': 300000,
        'gasPrice': web3.toWei('1', 'gwei'),
        'from': _loaner,
        'nonce': web3.eth.getTransactionCount(_loaner)
    })
    privateKey = getpass("Enter your password: ")
    signed_txn = web3.eth.account.signTransaction(transaction, private_key=privateKey)
    transaction_hash = web3.eth.sendRawTransaction(web3.toHex(signed_txn.rawTransaction))
    return


# In[68]:


confirmInstallment(loanerIndex, loansContract, organizationContract, loaner, accountsConract)

# In[ ]:

'''
