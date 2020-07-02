from django.shortcuts import render
from CreditHistorySite.src import main
from CreditHistorySite.src.loanie import Loanie


def index(request):
    return render(request, 'index.html')


def login(request):
    return render(request, 'login.html')


def orgSignup(request):
    if request.method == 'POST':
        name = request.POST['name']
        commercial_no = request.POST['commercial_no']
        logo = request.POST['logo']
        password = request.POST['password']
        public_key = request.POST['publickey']

        # Save in database



    else:
        return render(request, 'orgSignup.html')

def orgHome(request):


    return render(request, 'orghome.html')
    
def userSignup(request):
    if request.method == 'POST':
        name = request.POST['name']
        private_key = request.POST['private_key']
    else:
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
