import json
from web3 import Web3
import os
import platform
operating_system = platform.system()
d = '/'
if operating_system == 'Windows':
    d = '\\'

ganache_url = "HTTP://127.0.0.1:7545"
web3 = Web3(Web3.HTTPProvider(ganache_url))
# This is our main account that controls everything
web3.eth.defaultAccount = web3.eth.accounts[0]


 

# Get the organization contract address
with open('..'+ d +'build'+ d +'contracts'+ d +'Organization.json') as orgFile:
	orgJson=json.load(orgFile)
	organizationContractABI =orgJson['abi']
	organizationContractAdd=web3.toChecksumAddress(orgJson['networks']['5777']['address'])
organizationContract = web3.eth.contract(address=organizationContractAdd, abi=organizationContractABI)


# Get the accounts contract address
with open('..'+ d +'build'+ d +'contracts'+ d +'Accounts.json') as accFile:
	accountJson=json.load(accFile)
	accountsContractABI = accountJson['abi']
	accountsContractAdd= web3.toChecksumAddress(accountJson['networks']['5777']['address'])
accountsConract = web3.eth.contract(address=accountsContractAdd, abi=accountsContractABI)


# Put dummy user account and org account
def addUsers():
	accountsConract.functions.add(web3.eth.accounts[1], False).transact()
	accountsConract.functions.add(web3.eth.accounts[2], False).transact()
	accountsConract.functions.add(web3.eth.accounts[5], True).transact()
	accountsConract.functions.add(web3.eth.accounts[6], True).transact()

def deleteUser():
	accountsConract.functions.deleteAccount(web3.eth.accounts[1]).transact()

def createLoan(_address,_amount):
	check=organizationContract.functions.createLoan(_address,_amount).transact()	
	return check

addUsers()
deleteUser()

# Suppose bank wants to create a loan
loanieAddress = input("Enter the addrses: ")
### Check to see whether it is a user or organization address
index = accountsConract.functions.getIndex(loanieAddress).call()


if index != -1:
	loanieType = accountsConract.functions.getType(index).call()
	if not loanieType:
		 #res = organizationContract.functions.createLoan(loanieAddress).call()
		res=True
		print(res)
	else :
		choice=input("create loan Y/N?")
		if choice=="Y":
			if createLoan(web3.eth.accounts[5],1000):
				print("Loan created")
else:
	print("This account is not registered in our system.")

