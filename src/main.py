import json
from web3 import Web3
import os
import platform
from getpass import getpass


operating_system = platform.system()
d = '/'
if operating_system == 'Windows':
    d = '\\'

ganache_url = "HTTP://127.0.0.1:7545"
web3 = Web3(Web3.HTTPProvider(ganache_url))
# This is our main account that controls everything
web3.eth.defaultAccount = web3.eth.accounts[0]


def getContract(filename):
	with open('..'+ d +'build'+ d +'contracts'+ d +filename) as contractFile:
		contractJson=json.load(contractFile)
		contractABI =contractJson['abi']
		contractAdd=web3.toChecksumAddress(contractJson['networks']['5777']['address']) 
		return contractABI, contractAdd



# Get the organization contract address
organizationContractABI, organizationContractAdd = getContract('Organization.json')	
organizationContract = web3.eth.contract(address=organizationContractAdd, abi=organizationContractABI)

#get the user contract address
userContractABI,userContractAdd = getContract('User.json')
userContract = web3.eth.contract(address=userContractAdd, abi=userContractABI)

# Get the accounts contract address
accountsContractABI,accountsContractAdd = getContract('Accounts.json')
accountsConract = web3.eth.contract(address=accountsContractAdd, abi=accountsContractABI)

loansContractABI, loansContractAddress= getContract('Loans.json')
userContract.functions.setLoansContractAddress(loansContractAddress)

# Put dummy user account and org account
def addUsers():
	accountsConract.functions.add(web3.eth.accounts[1], False).transact()
	accountsConract.functions.add(web3.eth.accounts[2], False).transact()
	accountsConract.functions.add(web3.eth.accounts[5], True).transact()
	accountsConract.functions.add(web3.eth.accounts[6], True).transact()

def deleteUser():
	accountsConract.functions.deleteAccount(web3.eth.accounts[1]).transact()

def createLoan(_address,_loaner,_amount,_loansContractAddress):
	organizationContract.functions.setLoansContractAddress(_loansContractAddress).transact();
	check=organizationContract.functions.createLoan(_address,_loaner,_amount).transact()	
	return check

addUsers()
deletuser = input("delete user? Y/N")
if deletuser == 'Y':
	deleteUser()


def getPendingLoans(_userContract, _pk=None):
    pendingLoans = _userContract.functions.getPendingLoans().buildTransaction({'gas': 70000,'gasPrice': web3.toWei('1', 'gwei'),'from': loanieAddress,'nonce': web3.eth.getTransactionCount(loanieAddress)}) 
    print(type(pendingLoans))
    private_key = getpass('Enter your key: ') if _pk is not None else _pk
    test_transaction = {'gas': 70000,'gasPrice': web3.toWei('1', 'gwei'),'from': loanieAddress,
                        'nonce': web3.eth.getTransactionCount(loanieAddress), 'data':pendingLoans['data']}
    print(type(test_transaction))
    signed_txn = web3.eth.account.signTransaction(test_transaction, private_key=private_key)
    print(signed_txn)
    transaction_hash = web3.eth.sendRawTransaction(signed_txn.rawTransaction)
    print('Transaction Block: \n', web3.eth.getTransaction(transaction_hash))
    print('Transaction Receipt: \n', web3.eth.getTransactionReceipt(transaction_hash))
    print('Pending loan ended!')


# Suppose bank wants to create a loan
loanieAddress = input("Enter the addrses: ")

### Check to see whether it is a user or organization address
index = accountsConract.functions.getIndex(loanieAddress).call()

pk = '8700bbbe5cc527282fc13aa85dfc9cbe2493cdaa4b87fea14c0b30ad56c129d7'
if index != -1:
	loanieType = accountsConract.functions.getType(index).call()
	if not loanieType:
		 #res = organizationContract.functions.createLoan(loanieAddress).call()
		res=True
		print(res)
		choice=input("pending loans Y or N")
		if choice == "Y":
			getPendingLoans(userContract, pk)

	else :
		choice=input("create loan Y/N?")
		if choice=="Y":
			if createLoan(web3.eth.accounts[2],web3.eth.accounts[6],1000,loansContractAddress):
				print("Loan created")
else:
	print("This account is not registered in our system.")

