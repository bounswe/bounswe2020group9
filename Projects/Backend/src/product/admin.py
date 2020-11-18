from django.contrib import admin

from product.models import Product, Order, Comment, ProductList, Payment, Label, Category, Notification

# Register your models here.

admin.site.register(Product)

admin.site.register(Order)

admin.site.register(Comment)

admin.site.register(ProductList)

admin.site.register(Payment)

admin.site.register(Label)

admin.site.register(Category)

admin.site.register(Notification)