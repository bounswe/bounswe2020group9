from django.contrib.auth.models import AbstractUser
from django.db import models


# Create your models here.

class User(AbstractUser):
    USER_TYPES = (
        (1, "Customer"),
        (2, "Vendor"),
        (3, "Admin")
    )
    user_type = models.PositiveSmallIntegerField(choices=USER_TYPES, default=0)

    def __str__(self):
        return self.email


class Vendor(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True)


class Customer(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True)


class Admin(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True)
