from django.db import models
from user.models import Vendor

# Create your models here.

class Product(models.Model):
    name = models.CharField(max_length=255)
    vendor = models.ForeignKey(
        Vendor,
        on_delete=models.CASCADE,
        related_name="products"
    )