from django.contrib.auth.backends import BaseBackend
from CreditHistorySite.models import CustomUser, CustomUserType
from django.core.exceptions import ObjectDoesNotExist


class AddressBackend(BaseBackend):
    def authenticate(self, request, username=None, password=None, **kwargs):
        # we made our publicKey the primary key of the CustomUser model
        try:
            customUser = CustomUser.objects.get(pk=username)
            # testing
        except CustomUser.DoesNotExist:
            return None

        if customUser.type == CustomUserType.Organization.value:
            org = customUser.org_profile
            keystore = org.keystore
        else:
            loanie = customUser.loanie_profile
            keystore = loanie.keystore

        # decrypt here
        ethAccount = kwargs['ethAccount']
        privateKey = ethAccount.decrypt(keystore, password)
        request.session['privateKey'] = privateKey
        print('private key in session', request.session.get('privateKey'))
        if privateKey is not None:
            return customUser
        else:
            return None

    def get_user(self, user_id):
        try:
            customUser = CustomUser.objects.get(pk=user_id)
            return customUser
        except CustomUser.DoesNotExist:
            return None
