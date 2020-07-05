from django.contrib.auth.models import AbstractUser
from django.db import models
from enum import Enum


class CustomUserType(Enum):
    loanie = False
    Organization = True


class CustomUser(AbstractUser):
    type = models.BooleanField(default=None)  # False=Loanie, True=Organization

    def __str__(self):
        return self.username


class UserProfile(models.Model):
    user = models.OneToOneField(CustomUser, on_delete=models.CASCADE, blank=True, related_name='profile',
                                primary_key=True)

    class Meta:
        abstract = True


class Organization(UserProfile):
    user = models.OneToOneField(CustomUser, on_delete=models.CASCADE, blank=True, related_name='org_profile')
    commertialNum = models.CharField(max_length=100)
    publicKey = models.CharField(max_length=42)
    keystore = models.FileField(upload_to='keystores/organizations/{0}'.format(CustomUser.pk))
    # We should add a logo later


class Loanie(UserProfile):
    user = models.OneToOneField(CustomUser, on_delete=models.CASCADE, blank=True, related_name='loanie_profile')
    publicKey = models.CharField(max_length=42)
    keystore = models.FileField(upload_to='keystores/loanies/{0}'.format(CustomUser.pk))


# to make an object from Organization
'''
customUser = CustomUser(first_name='first', email='email@example.com', ..., type=CustomUserType.Organization.value)
userProfile = UserProfile(user=customUser)
customUser.save()
org1 = Organization(user=customUser, commertialNum='42424', ...)
org1.save()
'''
