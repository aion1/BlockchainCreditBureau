from django.shortcuts import render
from CreditHistorySite.src import main
from CreditHistorySite.src.loanie import Loanie


def index(request):
    return render(request, 'index.html')


def login(request):
    return render(request, 'login.html')


def orgSignup(request):
    return render(request, 'orgSignup.html')


def orgHome(request):
    return render(request, 'orghome.html')


def userSignup(request):
    if request.method == 'POST':
        name = request.POST['name']
        private_key = request.POST['private_key']
    else:
        return render(request, 'userSignup.html')


def afterSignup(request):
    dataSent, successSignup = False, False
    if request.method == 'POST':
        dataSent = True
    if dataSent:
        name = request.POST['name']
        commercial_no = request.POST['commercial_no']
        logo = request.POST['logo']
        password = request.POST['password']
        publicKey = request.POST['publickey']
        privateKey = request.POST['privatekey']

        userObject = None # This should have all the helper function and also have web3


        # ALERT: THIS IS TEMPORARY IN DEVELOPMENT, SHOULD BE CHANGED WHEN MIGRATING TO THE MAINNET
        # validate that this public key is on the Ganache private chain on our node
        ecryptedAccount = web3.eth.account.encrypt('8700bbbe5cc527282fc13aa85dfc9cbe2493cdaa4b87fea14c0b30ad56c129d7',
                                            'waliedahmed')

        # Save in database

    return render(request, 'afterSignup.html', {'successSignup': successSignup})


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
