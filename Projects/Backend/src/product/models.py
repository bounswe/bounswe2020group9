from django.db import models
from user.models import Vendor, Customer, User


# Create your models here.


class ProductList(models.Model):
    name = models.CharField(max_length=255)
    owner = models.ForeignKey(Customer, on_delete=models.CASCADE)


class Product(models.Model):
    name = models.CharField(max_length=255)
    # image = models.ImageField(upload_to ='pics')#option is to select media directory TODO need to implement
    brand = models.CharField(max_length=255)
    price = models.FloatField()
    vendor = models.ForeignKey(
        Vendor,
        on_delete=models.CASCADE,
        related_name="products"
    )
    in_lists = models.ManyToManyField(ProductList)
    in_carts = models.ManyToManyField(Customer, related_name="cart_list")
    in_alerted_lists = models.ManyToManyField(Customer, related_name="in_alerted_list")


class Label(models.Model):
    name = models.CharField(max_length=255, unique=True)
    products = models.ManyToManyField(Product, related_name="labels")


class Category(models.Model):
    name = models.CharField(max_length=255, unique=True)
    parent = models.ForeignKey("self", default=0, on_delete=models.CASCADE, db_constraint=False)
    products = models.ManyToManyField(Product, related_name="categories")


class Order(models.Model):
    STATUS_TYPES = (
        (1, "Preparing"),
        (2, "On the Way"),
        (3, "Delivered"),
    )
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    timestamp = models.DateTimeField()
    delivery_time = models.DateTimeField()
    current_status = models.PositiveSmallIntegerField(choices=STATUS_TYPES, default=1)


class Notification(models.Model):
    type = models.CharField(max_length=255)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    body = models.CharField(max_length=255)


class Comment(models.Model):
    RATES = (
        (1, "Awful"),
        (2, "Bad"),
        (3, "Mediocre"),
        (4, "Good"),
        (5, "Excellent"),
    )
    timestamp = models.DateTimeField()
    body = models.CharField(max_length=255)
    rating = models.PositiveSmallIntegerField(choices=RATES, default=5)
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)


class Payment(models.Model):
    owner = models.ForeignKey(Customer, on_delete=models.CASCADE)
    # Below are cart info, TODO encrypt them
    card_id = models.CharField(max_length=16)
    date_month = models.CharField(max_length=2)
    date_year = models.CharField(max_length=2)
    cvv = models.CharField(max_length=3)
