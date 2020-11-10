from django.db import models
from user.models import Vendor, Customer

# Create your models here.


class ProductList(models.Model):
    name = models.CharField(max_length=255)
    owner = models.ForeignKey(Customer, on_delete=models.CASCADE)

    
class Product(models.Model):
    name = models.CharField(max_length=255)
    vendor = models.ForeignKey(
        Vendor,
        on_delete=models.CASCADE,
        related_name="products"
    )
    in_lists = models.ManyToManyField(ProductList)
    in_carts = models.ManyToManyField(Customer, related_name="cart_list")
    in_alerted_lists = models.ManyToManyField(Customer, related_name="in_alerted_list")


class Order(models.Model):
    vendor = models.ForeignKey(Vendor, default=1, on_delete=models.CASCADE)
    customer = models.ForeignKey(Customer, default=1, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, default=1, on_delete=models.CASCADE)
    dummy = models.IntegerField()
    timestamp = models.DateTimeField()


class Comment(models.Model):
    timestamp = models.DateTimeField()
    body = models.CharField(max_length=255)
    owner = models.ForeignKey(Customer, on_delete=models.CASCADE)
    product = models.OneToOneField(Product, on_delete=models.CASCADE)