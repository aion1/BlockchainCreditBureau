from django.contrib.auth import authenticate
from django.contrib.auth import login as authLogin
from django.contrib.auth.decorators import login_required
from django.db import IntegrityError
from django.shortcuts import render, redirect

from CreditHistorySite.models import CustomUser, CustomUserType, CustomUserProfile, Organization, Loanie
from CreditHistorySite.src import main
from CreditHistorySite.src.loanie import Web3Loanie
from CreditHistorySite.src.utility import EthAccount


def index(request):
    return render(request, 'index.html')


def login(request):
    if 'POST' != request.method:
        response = render(request, 'login.html')
    else:
        publicKey = request.POST['publickey']
        password = request.POST['password']

        ethAccount = EthAccount(main.web3Handler)
        # teset
        print('innisifnisnf')
        customUser = authenticate(request, username=publicKey, password=password, ethAccount=ethAccount)

        # authenticate
        if customUser is not None:
            # 1. determine if account exists
            # HINT: accountExists = AccountsContract.accountExist(publicKey);
            accountExists = True
            if accountExists:

                authLogin(request, customUser)

                # 5. access our accounts contract to see its type={loaine, organization}
                isLoanie = not customUser.type
                if isLoanie:
                    # get loanie loans and pendingLoans to show them
                    loans = None
                    pendingLoans = None
                    response = redirect('loanie.home')
                else:
                    # get organization loans and to show them
                    loans = None
                    response = redirect('org.home')
            else:
                errorMsg = 'This account does not exist. Please sign up.'
                response = render(request, 'error.html', {'errorMsg': errorMsg})


        else:
            # Return an 'invalid login' error message.
            errorMsg = 'This account does not exist. Please sign up.'
            response = render(request, 'error.html', {'errorMsg': errorMsg})
    return response


# to clean data and navigate after that to the url('org/home');
def orgSignup(request):
    successSignup = False
    if 'POST' != request.method:
        response = render(request, 'organization/signup.html')
    else:
        # Get the form data
        username = request.POST['username']
        email = request.POST['email']
        commercial_no = request.POST['commercial_no']
        password = request.POST['password']

        # validation should go here

        # a. create CustomUser
        customUser = CustomUser(username=username, email=email,
                                type=CustomUserType.Organization.value)
        customUserProfile = CustomUserProfile(customUser)

        # b. create the keystore that has the encrypted privatekey
        ethAccount = EthAccount(main.web3Handler)
        keystore = ethAccount.create(password)  # this creates an account and returns its associated keysotre

        customUser.publicKey = keystore['address']
        try:
            customUser.save()
            org = Organization(customUser=customUser, commertialNum=commercial_no, keystore=keystore)
            org.save()
            # Add the organization into our Accounts Contract
            accountsHandler = main.accsHandler
            accountsHandler.addAccount(customUser.publicKey, CustomUserType.Organization.value)

            # response = redirect('org.home')  # Should pass the data of the
            response = redirect('index')
        except IntegrityError:
            errorMsg = 'Sorry! This account already exists!'
            response = render(request, 'error.html', {'errorMsg': errorMsg})
    return response


# to clean up the data and navigate to the url('loanie/home');
def loanieSignup(request):
    if 'POST' != request.method:
        response = render(request, 'loanie/signup.html')
    else:
        # Get the form data
        username = request.POST['username']
        email = request.POST['email']
        password = request.POST['password']

        # validation should go here

        # a. create CustomUser
        customUser = CustomUser(username=username, email=email,
                                type=CustomUserType.Loanie.value)
        customUserProfile = CustomUserProfile(customUser)

        # b. create the keystore that has the encrypted privatekey
        ethAccount = EthAccount(main.web3Handler)
        keystore = ethAccount.create(password)  # this creates an account and returns its associated keysotre
        customUser.publicKey = keystore['address']
        try:
            customUser.save()
            loanie = Loanie(customUser=customUser, keystore=keystore)
            loanie.save()
            # Add the organization into our Accounts Contract
            accountsHandler = main.accsHandler
            accountsHandler.addAccount(customUser.publicKey, CustomUserType.Loanie.value)
            # response = redirect('org.home')  # Should pass the data of the
            response = redirect('index')
        except IntegrityError:
            errorMsg = 'Sorry! This account already exists!'
            response = render(request, 'error.html', {'errorMsg': errorMsg})

    return response



@login_required(login_url='login')
def orgHome(request):
    # show the data of a logged in organization
    return render(request, 'organization/home.html')


@login_required(login_url='login')
def loanieHome(request):
    # I should here have the publickey and password after logining in
    # Then resotre the privatekey from a keystore
    # Then show the loans and pending loans of a user in their home page
    public_key = input("Enter your public key: ")
    private_key = input("Enter your private key: ")
    web3Handler = main.web3Handler
    userContract = main.userContractClass
    accountsContract = main.accountsContractClass
    loanieObj = Web3Loanie(public_key, private_key, web3Handler, userContract)
    loanieObj.buildPendingLoansList(accountsContract)
    pendingLoans = loanieObj.pendingLoansList
    return render(request, 'loanie/home.html', {'pendingLoans': pendingLoans})

