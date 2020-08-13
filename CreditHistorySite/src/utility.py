import json
import os
import platform
from datetime import date
from web3 import Web3
from typing import List
from CreditHistorySite.settings import BASE_DIR
import pytz  # $ pip install pytz

tz = pytz.timezone("Africa/Cairo")

class TransactionDictionary:
    def __init__(self, gas, sender, web3):
        self.gas = gas
        self.web3 = web3
        self.sender = sender

    def __new__(cls, gas, sender, web3):
        cls.gas = gas
        cls.web3 = web3
        cls.sender = cls.web3.toChecksumAddress(sender)
        return dict({
            'gas': cls.gas,
            'gasPrice': cls.web3.toWei('1', 'gwei'),
            'from': cls.sender,
            'nonce': cls.web3.eth.getTransactionCount(cls.sender)
        })


class EthTransactionDict:
    def __init__(self, gas, sender, web3, to, value):
        self.gas = gas
        self.web3 = web3
        self.sender = sender
        self.to = to
        self.value = value

    def __new__(cls, gas, sender, web3, to, value):
        cls.gas = gas
        cls.web3 = web3
        cls.sender = cls.web3.toChecksumAddress(sender)
        cls.to = cls.web3.toChecksumAddress(to)
        cls.value = value
        return dict({
            'gas': cls.gas,
            'gasPrice': cls.web3.toWei('1', 'gwei'),
            'from': cls.sender,
            'to': cls.to,
            'value': cls.web3.toWei(cls.value, 'ether'),
            'nonce': cls.web3.eth.getTransactionCount(cls.sender)
        })


class Web3Handler:
    def __init__(self, ganache_url):
        self.ganache_url = ganache_url
        self.web3 = Web3(Web3.HTTPProvider(ganache_url))
        operating_system = platform.system()
        self.d = '/'
        if operating_system == 'Windows':
            self.d = '\\'
        self.web3.eth.defaultAccount = self.web3.eth.accounts[0]
        self.defaultAccount = self.web3.eth.defaultAccount

        self.defaultKey = 'a4763483f8b44b18a205ab8c86f87b61ea2f214da53eb703207458a1aafbfa89'

        self.ethAccount = self.web3.eth.account

    def getContractABI(self, filename):
        with open(os.path.join(BASE_DIR, (
                'Solidity' + self.d + 'build' + self.d + 'contracts' + self.d + filename))) as contractFile:
            contractJson = json.load(contractFile)
            contractABI = contractJson['abi']
            return contractABI

    def getContractAddress(self, filename):
        with open(os.path.join(BASE_DIR, (
                'Solidity' + self.d + 'build' + self.d + 'contracts' + self.d + filename))) as contractFile:
            contractJson = json.load(contractFile)
            contractAdd = self.web3.toChecksumAddress(contractJson['networks']['5777']['address'])
            return contractAdd

    def getContract(self, filename):
        contractABI, contractAdd = self.getContractABI(filename), self.getContractAddress(filename)
        contract = self.web3.eth.contract(address=contractAdd, abi=contractABI)
        return contract

    def transact(self, transaction, private_key):
        signed_txn = self.web3.eth.account.signTransaction(transaction, private_key=private_key)
        transaction_hash = self.web3.eth.sendRawTransaction(self.web3.toHex(signed_txn.rawTransaction))
        return transaction_hash

    def getTransactionReceipt(self, transaction_hash):
        return self.web3.eth.getTransactionReceipt(transaction_hash)

    def getAccount(self, index):
        return self.web3.eth.accounts[index]

    def createNewAccount(self, password):
        new_account = self.web3.eth.account.create()
        tx_hash = self.sendEthFromDefault(new_account.address, 3)
        keystore = self.web3.eth.account.encrypt(new_account.privateKey, password)
        return keystore

    def sendEthFromDefault(self, receiver, amount):
        transactionDict = EthTransactionDict(gas=100000,
                                             sender=self.defaultAccount,
                                             web3=self.web3,
                                             value=amount,
                                             to=receiver)
        return self.transact(transactionDict, self.defaultKey)

    def toChecksumAddress(self, address):
        return self.web3.toChecksumAddress(address)


class AccountsHandler:
    def __init__(self, web3Handler, accountsContract):
        self.web3Handler = web3Handler
        self.accountsContract = accountsContract

    def addAccount(self, public_key, account_type):
        public_key = self.web3Handler.web3.toChecksumAddress(public_key)
        self.accountsContract.functions.add(public_key, account_type).transact()


class Installment:
    def __init__(self, amount, payDate, payOutDate, paid):
        self.amount = amount
        self.payDate = date.fromtimestamp(int(payDate))
        if int(payOutDate) == 0:
            self.payOutDate = None
        else:
            self.payOutDate = date.fromtimestamp(int(payOutDate))
        self.paid = paid




class Loan:
    def __init__(self, amount, loanerAddress, loanieAddress, id, installmentsNum, interest,
                 installments: List[Installment]):
        self.amount = amount
        self.loanerAddress = loanerAddress
        self.loanieAddress = loanieAddress
        self.id = id
        self.installmentsNum = installmentsNum
        self.interest = interest
        self.installments = installments

class EthAccount:
    def __init__(self, web3Handler):
        self.web3Handler = web3Handler

    def create(self, password):
        keystore = self.web3Handler.createNewAccount(password)
        return keystore

    def decrypt(self, keystore, password):
        privateKey = self.web3Handler.web3.eth.account.decrypt(keystore, password)
        # self.web3Handler.web3.toChecksumAddress
        return self.web3Handler.web3.toHex(privateKey)
