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
organizationContractAdd = web3.toChecksumAddress('0xdA3F8763B51A5D0c0Daad2e96Ed3Cfad791AeDAC')
with open('..'+ d +'build'+ d +'contracts'+ d +'Organization.json') as orgFile:
	organizationContractABI = json.load(orgFile)['abi']
organizationContract = web3.eth.contract(address=organizationContractAdd, abi=organizationContractABI)


# Get the accounts contract address
accountsContractAdd = web3.toChecksumAddress('0x8ad0c4512e09e708d71949be98a62db494Ec388A')
with open('..'+ d +'build'+ d +'contracts'+ d +'Accounts.json') as accFile:
	accountsContractABI = json.load(accFile)['abi']
accountsConract = web3.eth.contract(address=accountsContractAdd, abi=accountsContractABI)

# Put dummy user account and org account
def addUsers():
	accountsConract.functions.add(web3.eth.accounts[1], False).transact()
	accountsConract.functions.add(web3.eth.accounts[2], False).transact()
	accountsConract.functions.add(web3.eth.accounts[5], True).transact()
	accountsConract.functions.add(web3.eth.accounts[6], True).transact()

addUsers()


# Suppose bank wants to create a loan
loanieAddress = '0xa2D0B6dbCd04a789da44CCECA9d66B6dfc93A124'
### Check to see whether it is a user or organization address
index = accountsConract.functions.getIndex(loanieAddress).call()

if index != -1:
	loanieType = accountsConract.functions.getType(index).call()
	if not loanieType:
		res = organizationContract.functions.createLoan(loanieAddress).call()
else:
	print("This account is not registered in our system.")


