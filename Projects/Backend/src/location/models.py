from django.db import models

# Create your location models here.
from user.models import User


class Location(models.Model):
    address_name = models.CharField(max_length=255)
    address = models.CharField(max_length=255)
    postal_code = models.IntegerField()
    country = models.CharField(max_length=255)
    city = models.CharField(max_length=255)
    longitude = models.FloatField(default=0)
    latitude = models.FloatField(default=0)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
