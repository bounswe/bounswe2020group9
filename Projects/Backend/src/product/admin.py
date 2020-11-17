from django.contrib import admin
from product.models import Product,Order,Comment,ProductList,CartList,AlertedList,Categories,Labels, Payment, Label, Category, Notification
# Register your models here.

admin.site.register(Product)

admin.site.register(Order)

admin.site.register(Comment)

admin.site.register(ProductList)

admin.site.register(Payment)

admin.site.register(Label)

admin.site.register(Category)

admin.site.register(Notification)

admin.site.register(CartList)

admin.site.register(AlertedList)

admin.site.register(Categories)

admin.site.register(Labels)
