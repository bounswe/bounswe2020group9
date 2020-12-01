from django.conf import settings
from django.contrib.auth.models import AbstractUser
from django.db import models
from django.db.models.signals import post_save
from django.dispatch import receiver
from rest_framework.authtoken.models import Token


# Create your models here.

class User(AbstractUser):
    USER_TYPES = (
        (1, "Customer"),
        (2, "Vendor"),
        (3, "Admin")
    )
    user_type = models.PositiveSmallIntegerField(choices=USER_TYPES, default=1)
    bazaar_point = models.PositiveSmallIntegerField(default=0)

    def __str__(self):
        return self.email + ", (" + str(self.USER_TYPES[self.user_type - 1][1]) + ")"


class Vendor(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True)

    def __str__(self):
        return self.user.email


class Customer(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True)

    def __str__(self):
        return self.user.email


class Admin(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True)

    def __str__(self):
        return self.user.email



@receiver(post_save, sender=settings.AUTH_USER_MODEL)
def create_auth_token(sender, instance=None, created=False, **kwargs):
    if created:
        Token.objects.create(user=instance)
