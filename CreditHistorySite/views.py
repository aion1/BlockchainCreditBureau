from django.shortcuts import render
from CreditHistorySite.src import main
from CreditHistorySite.src.loanie import Loanie


def index(request):
    return render(request, 'index.html')


def login(request):
    return render(request, 'login.html')


def orgSignup(request):
    return render(request, 'orgSignup.html')


def userSignup(request):
    return render(request, 'userSignup.html')


def loanie(request):
    # I should here have the address and private_key
    public_key = input("Enter your public key: ")
    private_key = input("Enter your private key: ")
    web3Handler = main.web3Handler
    userContract = main.userContractClass
    accountsContract = main.accountsContractClass
    loanieObj = Loanie(public_key, private_key, web3Handler, userContract)
    loanieObj.buildPendingLoansList(accountsContract)
    pendingLoans = loanieObj.pendingLoansList
    return render(request, 'loanieHome.html', {'pendingLoans': pendingLoans})
