"""CreditHistorySite URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from . import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', views.index, name='index'),
    path('login', views.showLoginPage, name='login'),

    # Intermediate page to determine whether the user is a loanie or organization
    # after logging in
    path('home', views.home, name='home'),

    # Signup urls
    path('org/signup', views.showOrgSignupPage, name='org.signup'),
    path('org/signedup', views.orgSignedup, name='org.signedup'),
    path('loanie/signup', views.showLoanieSignupPage, name='loanie.signup'),
    path('loanie/signedup', views.loanieSignedup, name='loanie.signedup'),

    # After logging in urls (must be authenticated)
    path('loanie/home', views.loanieHome, name='loanie.home'),
    path('org/home', views.orgHome, name='org.home'),

]
