from django.conf import settings
from django.contrib.auth.models import AbstractUser
from django.db import models
from django.db.models.signals import post_save
from django.dispatch import receiver
from rest_framework.authtoken.models import Token


# Create your user models here.
# There are 4 User Tables, User, Customer, Vendor, Admin


class User(AbstractUser):
    """
    Every user is one of three: Customer, Vendor or Admin
    Every user also has a related field in the related table,
    """
    USER_TYPES = (
        (1, "Customer"),
        (2, "Vendor"),
        (3, "Admin")
    )
    user_type = models.PositiveSmallIntegerField(choices=USER_TYPES, default=1)
    bazaar_point = models.PositiveSmallIntegerField(default=0)
    company = models.CharField(max_length=255, blank=True)
    is_banned = models.BooleanField(default=False)

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
