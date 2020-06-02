from django.shortcuts import render
from CreditHistorySite.src import main


def index(request):
    hah = main.accountsContractAdd
    return render(request, 'index.html', {'hah': hah})
