from django.db import models
from user.models import Vendor, Customer

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
    image = models.ImageField(upload_to ='pics')#option is to select media directory
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


class Order(models.Model):
    customer_id = models.ForeignKey(Customer, default=1, on_delete=models.CASCADE)
    product_id = models.ForeignKey(Product, default=1, on_delete=models.CASCADE)
    timestamp = models.DateTimeField()
    delivery_time = models.DataTimeField()
    current_status = models.CharField(max_length=255)


class Comment(models.Model):
    timestamp = models.DateTimeField()
    body = models.CharField(max_length=255)
    customer_id = models.ForeignKey(Customer, on_delete=models.CASCADE)
    rating = models.IntegerField()
    product_id = models.ForeignKey(Product, on_delete=models.CASCADE)