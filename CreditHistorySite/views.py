from django.shortcuts import render, redirect
from CreditHistorySite.src import main
from CreditHistorySite.src.loanie import Loanie


def index(request):
    return render(request, 'index.html')


# Transparent to the user type
def showLoginPage(request):
    return render(request, 'login.html')


# Will show the signup page
def showOrgSignupPage(request):
    return render(request, 'organization/signup.html')


def showLoanieSignupPage(request):
    return render(request, 'loanie/signup.html')


# to clean data and navigate after that to the url('org/home');
def orgSignedup(request):
    dataSent, successSignup = False, False
    if request.method == 'POST':
        dataSent = True
    if dataSent:
        # Get the form data
        name = request.POST['name']
        commercial_no = request.POST['commercial_no']
        logo = request.POST['logo']
        password = request.POST['password']
        publicKey = request.POST['publickey']
        privateKey = request.POST['privatekey']

        userObject = None  # This should have all the helper function and also have web3

        # add the account in the Accounts contract
        accountExists = False
        if accountExists:
            errorMsg = 'Sorry this account exists in our system.'
            response = render(request, 'error.html', {'errorMsg': errorMsg})

        # ALERT: THIS IS TEMPORARY IN DEVELOPMENT, SHOULD BE CHANGED WHEN MIGRATING TO THE MAINNET
        # validate that this public key is on the Ganache private chain on our node
        # ecryptedAccount = web3.eth.account.encrypt('8700bbbe5cc527282fc13aa85dfc9cbe2493cdaa4b87fea14c0b30ad56c129d7',
        # 'waliedahmed')

        # Save in database
        savedInDB = False
        if not savedInDB:
            errorMsg = 'Some error happend. Sorry for that'
            response = render(request, 'error.html', {'errorMsg': errorMsg})
        else:
            response = redirect('org.home')  # Should pass the data of the
            # just-registered organization
    else:
        # the request is not a POST request
        errorMsg = 'Some error happend. This is not a POST request, please' \
                   'try again.'
        response = render(request, 'error.html', {'errorMsg': errorMsg})

    return response


# to clean up the data and navigate to the url('loanie/home');
def loanieSignedup(request):
    # process the data

    return redirect('loanie.home')


def orgHome(request):
    return render(request, 'organization/home.html')


def loanieHome(request):
    # I should here have the publickey and password after logining in
    # Then resotre the privatekey from a keystore
    # Then show the loans and pending loans of a user in their home page
    public_key = input("Enter your public key: ")
    private_key = input("Enter your private key: ")
    web3Handler = main.web3Handler
    userContract = main.userContractClass
    accountsContract = main.accountsContractClass
    loanieObj = Loanie(public_key, private_key, web3Handler, userContract)
    loanieObj.buildPendingLoansList(accountsContract)
    pendingLoans = loanieObj.pendingLoansList
    return render(request, 'loanie/home.html', {'pendingLoans': pendingLoans})


# Will go to different home page depending on the user type
# Will be called after successful login
def home(request):
    publicKey = request.POST['publickey']
    password = request.POST['password']

    # authenticate

    # 1. determine if account exists
    # HINT: accountExists = AccountsContract.accountExist(publicKey);
    accountExists = False
    if accountExists:
        # determine if it's a loanie or organization
        # 2. get keystore location from database

        # 3. access this keystore on your file system

        # 4. privateKey = web3.eth.account.decrypt(keystore, password)

        # 5. access our accounts contract to see its type={loaine, organization}
        isLoanie = False
        if isLoanie:
            # get loanie loans and pendingLoans to show them
            loans = None
            pendingLoans = None
            response = render(request, 'loanie/home.html', {'loans': loans,
                                                            'pendingLoans': pendingLoans})

        else:
            # get organization loans and to show them
            loans = None
            response = render(request, 'organization/home.html', {'loans': loans})

    else:
        errorMsg = 'This account does not exist. Please sign up.'
        response = render(request, 'error.html', {'errorMsg': errorMsg})

    return response
