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

        try:
            org = customUser.org_profile
            keystore = org.keystore
            # decrypt here
            ethAccount = kwargs['ethAccount']
            privateKey = ethAccount.decrypt(keystore, password)
            print(privateKey)

            request.session['privateKey'] = privateKey

            print(request.session['privateKey'])
            if privateKey is not None:
                return customUser

        except ObjectDoesNotExist:
            try:
                loanie = customUser.loanie_profile
                keystore = loanie.keystore
                # decrypt here
                ethAccount = kwargs['ethAccount']
                privateKey = ethAccount.decrypt(keystore, password)
                print(privateKey)
                request.session['privateKey'] = privateKey
                if privateKey is not None:
                    return customUser

            except ObjectDoesNotExist:
                return None

    def get_user(self, user_id):
        try:
            customUser = CustomUser.objects.get(pk=user_id)
            return customUser
        except CustomUser.DoesNotExist:
            return None
