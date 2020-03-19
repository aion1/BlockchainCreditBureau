import json
from web3 import Web3
import os

ganache_url = "HTTP://127.0.0.1:7545"
web3 = Web3(Web3.HTTPProvider(ganache_url))
# This is our main account that controls everything
web3.eth.defaultAccount = web3.eth.accounts[0]


# Suppose bank wants to create a loan
 

# Get the organization contract address
organizationContractAdd = web3.toChecksumAddress('0x255A0901AdA7eA2292aec6532ED4B409D7A9FDc0')
with open('../build/contracts/Organization.json') as orgFile:
	organizationContractABI = json.load(orgFile)['abi']
organizationContract = web3.eth.contract(address=organizationContractAdd, abi=organizationContractABI)


# Get the accounts contract address
accountsContractAdd = web3.toChecksumAddress('0x3e3c76571595C9eaD640310AB00734F3982D2ea0')
with open('../build/contracts/Accounts.json') as accFile:
	accountsContractABI = json.load(accFile)['abi']
accountsConract = web3.eth.contract(address=accountsContractAdd, abi=accountsContractABI)

# Put dummy user account and org account
def addUsers():
	accountsConract.functions.add(web3.eth.accounts[1], False).transact()
	accountsConract.functions.add(web3.eth.accounts[2], False).transact()
	accountsConract.functions.add(web3.eth.accounts[5], True).transact()
	accountsConract.functions.add(web3.eth.accounts[6], True).transact()

#addUsers()



