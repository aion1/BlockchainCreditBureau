from django.contrib.auth.backends import BaseBackend
from CreditHistorySite.models import CustomUser, CustomUserType
from django.core.exceptions import ObjectDoesNotExist
from CreditHistorySite.src.jsonserializer import JSONField


class AddressBackend(BaseBackend):
    def authenticate(self, request, username=None, password=None, **kwargs):
        # we made our publicKey the primary key of the CustomUser model
        try:
            customUser = CustomUser.objects.get(pk=username)
            # testing
        except CustomUser.DoesNotExist:
            return None

        # To get the keystore
        if customUser.type == CustomUserType.Organization.value:
            org = customUser.org_profile
        else:
            loanie = customUser.loanie_profile

        # decrypt here
        ethAccount = kwargs['ethAccount']
        privateKey = ethAccount.decrypt(customUser.keystore, password)
        request.session['privateKey'] = privateKey
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
