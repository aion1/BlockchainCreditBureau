from django.contrib.auth import authenticate
from django.contrib.auth import login as authLogin
from django.contrib.auth import logout as authLogout
from django.contrib.auth.decorators import login_required
from django.db import IntegrityError
from django.shortcuts import render, redirect
from django.http import HttpResponse

from CreditHistorySite.models import CustomUser, CustomUserType, CustomUserProfile, Organization, Loanie
from CreditHistorySite.src import main
from CreditHistorySite.src.loanie import Web3Loanie
from CreditHistorySite.src.utility import EthAccount
from CreditHistorySite.src.organization import Web3Organization
from django.core.mail import send_mail
from django.core.mail import EmailMessage


def index(request):
    return render(request, 'index.html')


def logout(request):
    authLogout(request)
    return redirect('index')


def login(request):
    if 'POST' != request.method:
        response = render(request, 'login.html')
    else:
        if not request.user.is_authenticated:
            publicKey = request.POST['publickey']
            password = request.POST['password']

            ethAccount = EthAccount(main.web3Handler)
            # teset
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
                        response = redirect('loanie.home')
                    else:
                        response = redirect('org.home')
                else:
                    errorMsg = 'This account does not exist. Please sign up.'
                    response = render(request, 'error.html', {'errorMsg': errorMsg})


            else:
                # Return an 'invalid login' error message.
                errorMsg = 'This account does not exist. Please sign up.'
                response = render(request, 'error.html', {'errorMsg': errorMsg})
        else:
            response = redirect('index')
    return response


#  send_mail(
#     'Sign Up in BCB system',
#    'your public Address is '+publicAddress,
#   'bcbs.ourproject@gmail.com',
#  [email],
# fail_silently=False,
# )

# to send mail with public address of user or organization
def sendMail(publicAddress, email):
    try:
        msg = EmailMessage('Request Callback',
                         'your public Address is '+publicAddress, to=[email])
        msg.send()
        return True
    except:
        return False


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
        customUser.keystore = keystore
        try:
            customUser.save()
            org = Organization(customUser=customUser, commertialNum=commercial_no)
            org.save()
            # Add the organization into our Accounts Contract
            accountsHandler = main.accsHandler
            accountsHandler.addAccount(customUser.publicKey, CustomUserType.Organization.value)

            customUser = authenticate(request, username=customUser.publicKey, password=password, ethAccount=ethAccount)
            authLogin(request, customUser)
            sendMail(customUser.publicKey, email)
            response = redirect('org.home')
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
        customUser.keystore = keystore
        try:
            customUser.save()
            loanie = Loanie(customUser=customUser)
            loanie.save()
            # Add the organization into our Accounts Contract
            accountsHandler = main.accsHandler
            accountsHandler.addAccount(customUser.publicKey, CustomUserType.Loanie.value)

            customUser = authenticate(request, username=customUser.publicKey, password=password, ethAccount=ethAccount)
            authLogin(request, customUser)
            sendMail(customUser.publicKey,email)
            response = redirect('loanie.home')
        except IntegrityError:
            errorMsg = 'Sorry! This account already exists!'
            response = render(request, 'error.html', {'errorMsg': errorMsg})

    return response


@login_required(login_url='login')
def orgHome(request):
    if request.user.type != CustomUserType.Organization.value:
        response = redirect('loanie.home')
    else:
        public_key = request.user.pk
        private_key = request.session.get('privateKey')

        web3Org = Web3Organization(public_key, private_key,
                                   main.web3Handler,
                                   main.organizationContractPython,
                                   main.accountsContractPython,
                                   main.loansContractPython)
        loans = web3Org.buildLoansList()

        response = render(request, 'organization/home.html', {'loans': loans,
                                                              'publicKey': public_key})
    return response


@login_required(login_url='login')
def loanieHome(request):
    if request.user.type == CustomUserType.Loanie.value:
        public_key = request.user.pk
        private_key = request.session.get('privateKey')

        web3Loanie = Web3Loanie(public_key, private_key,
                                main.web3Handler,
                                main.userContractPython,
                                main.accountsContractPython,
                                main.loansContractPython)
        # Pending Laons
        pendingLoansList = web3Loanie.buildPendingLoansList()
        # Loans
        loans = web3Loanie.buildLoansList()
        response = render(request, 'loanie/home.html', {'pendingLoans': pendingLoansList,
                                                        'loans': loans,
                                                        'publicKey': public_key})
    else:
        response = redirect('org.home')
    return response


"""
Users' Behaviours
"""


# Organization
@login_required(login_url='login')
def createLoan(request):
    if request.user.type == CustomUserType.Loanie.value:
        response = redirect('loanie.home')
    else:
        if 'POST' != request.method:
            response = render(request, 'organization/createLoan.html')
        else:
            loanieAddress = request.POST['loanie']
            amount = int(request.POST['amount'])
            installmentsNum = int(request.POST['installmentsNumber'])
            interest = int(request.POST['interest'])

            publicKey = request.user.pk
            privateKey = request.session.get('privateKey')

            web3Organization = Web3Organization(publicKey, privateKey,
                                                main.web3Handler,
                                                main.organizationContractPython,
                                                main.accountsContractPython,
                                                main.loansContractPython)
            web3Organization.createLoan(
                loanieAddress, amount, installmentsNum, interest
            )
            response = redirect('org.home')

    return response


@login_required(login_url='login')
def searchLoanie(request, loaniePublicKey):
    if request.user.type == CustomUserType.Loanie.value:
        response = redirect('loanie.home')
    else:
        publicKey = request.user.pk
        privateKey = request.session.get('privateKey')
        web3Organization = Web3Organization(publicKey, privateKey,
                                            main.web3Handler,
                                            main.organizationContractPython,
                                            main.accountsContractPython,
                                            main.loansContractPython)
        loanieLoans = web3Organization.searchLoanie(loaniePublicKey)
        response = redirect('org.home')

    return response


@login_required(login_url='login')
def confirmInstallment(request):
    # Coming from AJAX
    if request.user.type == CustomUserType.Loanie.value:
        response = HttpResponse('unsuccessful')
    else:
        installmentId = request.GET['installmentId']
        installmentIndex, loanId = installmentId.split('_')

        publicKey = request.user.pk
        privateKey = request.session.get('privateKey')
        web3Organization = Web3Organization(publicKey, privateKey,
                                            main.web3Handler,
                                            main.organizationContractPython,
                                            main.accountsContractPython,
                                            main.loansContractPython)

        web3Organization.confrimInstallment(int(loanId), int(installmentIndex))
        # We should check here that the function performed well before returning success
        response = HttpResponse('Success')

    return response


# Loanie
@login_required(login_url='login')
def confirmPendingLoans(request):
    if request.user.type == CustomUserType.Organization.value:
        response = redirect('loanie.home')
    else:
        public_key = request.user.pk
        private_key = request.session.get('privateKey')
        loanId = int(request.POST['loanId'])
        web3Loanie = Web3Loanie(public_key, private_key,
                                main.web3Handler,
                                main.userContractPython,
                                main.accountsContractPython,
                                main.loansContractPython)
        web3Loanie.confirmPendingLoan(loanId)
        response = redirect('loanie.home')

    return response


@login_required(login_url='login')
def rejectPendingLoans(request):
    if request.user.type != CustomUserType.Loanie.value:
        response = redirect('loanie.home')
    else:
        public_key = request.user.pk
        private_key = request.session.get('privateKey')
        loanId = int(request.POST['loanId'])
        web3Loanie = Web3Loanie(public_key, private_key,
                                main.web3Handler,
                                main.userContractPython,
                                main.accountsContractPython,
                                main.loansContractPython)
        web3Loanie.rejectPendingLoan(loanId)
        response = redirect('loanie.home')


    return response
