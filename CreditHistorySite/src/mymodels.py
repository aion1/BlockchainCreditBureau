from django.db import models
from django.contrib.auth.models import User


class Organization(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    commertialNum = models.CharField(max_length=100)
    publicKey = models.CharField(max_length=42)
    # We should add a logo later
