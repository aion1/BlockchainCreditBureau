from django.shortcuts import render
from CreditHistorySite.src import main


def index(request):
    return render(request, 'index.html')


def login(request):
    return render(request, 'login.html')


def orgSignup(request):
    return render(request, 'orgSignup.html')


def userSignup(request):
    return render(request, 'userSignup.html')


def user(request):
    # I should here have the address and private_key

    return render(request, 'userhome.html')
