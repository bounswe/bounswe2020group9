from django.db import models
from user.models import Vendor, Customer, User


# Create your models here.


class ProductList(models.Model):
    name = models.CharField(max_length=255)
    customer_id = models.ForeignKey(Customer, on_delete=models.CASCADE)

class CartList(models.Model):
    customer_id = models.OneToOneField(Customer,on_delete=models.CASCADE)

class AlertedList(models.Model):
    customer_id = models.OneToOneField(Customer,on_delete=models.CASCADE)

class Categories(models.Model):
    category_name = models.CharField(max_length=255)
    parent_category_id = models.IntegerField()
    
class Labels(models.Model):
    label_name = models.CharField(max_length=255)

class Product(models.Model):
    name = models.CharField(max_length=255)
    vendor = models.ForeignKey(Vendor,on_delete=models.CASCADE,related_name="products")
    # image = models.ImageField(upload_to ='pics')#option is to select media directory TODO need to implement
    brand = models.CharField(max_length=255)
    price = models.FloatField()
    stock_counter = models.IntegerField()
    rating = models.FloatField()
    sell_counter = models.IntegerField()
    category_id = models.ForeignKey(Categories, on_delete=models.CASCADE)
    timestamp = models.DateTimeField()
    in_labels = models.ManyToManyField(Labels, related_name="label_list")
    in_lists = models.ManyToManyField(ProductList)
    in_carts = models.ManyToManyField(CartList, related_name="cart_list")
    in_alerted_lists = models.ManyToManyField(AlertedList, related_name="in_alerted_list")


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
