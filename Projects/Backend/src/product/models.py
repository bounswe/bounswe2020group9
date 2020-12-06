from django.db import models
from django.utils import timezone

from user.models import Vendor, Customer, User


# Create your models here.


class ProductList(models.Model):
    name = models.CharField(max_length=255)
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE)
    is_private = models.BooleanField(default=True) # private can only seen by owner
    is_alert_list = models.BooleanField(default=False) # True if it is an alert list

    def __str__(self):
        return self.customer.user.username + " - " + self.name


def productImage(instance, filename):
    return '/'.join(['images', str(instance.name), filename])


def productImage(instance, filename):
    return '/'.join(['images', str(instance.name), filename])



class Category(models.Model):
    name = models.CharField(max_length=255, unique=True)
    parent = models.ForeignKey("self", default=0, on_delete=models.CASCADE, db_constraint=False)
    # products = models.ManyToManyField(Product, related_name="categories", blank=True)

    def __str__(self):
        return self.name

class Product(models.Model):
    name = models.CharField(max_length=255)
    detail = models.CharField(max_length=511, blank=True)
    # image = models.ImageField(upload_to ='pics')#option is to select media directory TODO need to implement
    brand = models.CharField(max_length=255)
    price = models.FloatField()
    stock = models.IntegerField(default=0)
    rating = models.FloatField(default=0)
    sell_counter = models.IntegerField(default=0)
    release_date = models.DateTimeField(default=timezone.now)
    picture = models.ImageField(upload_to=productImage, null=True, blank=True)
    category = models.ForeignKey(Category, on_delete=models.CASCADE)

    vendor = models.ForeignKey(
        Vendor,
        on_delete=models.CASCADE,
        related_name="products"
    )

    in_lists = models.ManyToManyField(ProductList, blank=True)

    def __str__(self):
        return self.name + " " + self.vendor.user.username


class SubOrder(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE)
    amount = models.IntegerField(default=1)
    purchased = models.BooleanField(default=False)


class Label(models.Model):
    name = models.CharField(max_length=255, unique=True)
    products = models.ManyToManyField(Product, related_name="labels", blank=True)

    def __str__(self):
        return self.name



class Order(models.Model):
    STATUS_TYPES = (
        (1, "Preparing"),
        (2, "On the Way"),
        (3, "Delivered"),
    )
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    sub_order = models.ForeignKey(SubOrder, on_delete=models.CASCADE)
    timestamp = models.DateTimeField()
    delivery_time = models.DateTimeField()
    current_status = models.PositiveSmallIntegerField(choices=STATUS_TYPES, default=1)


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

class SearchHistory(models.Model):
    user =  models.ForeignKey(User, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)