from django.contrib import admin

from product.models import Product, Order, Comment, ProductList, Payment, Label, Category, SubOrder

# Register your models here.

admin.site.register(ProductList)

admin.site.register(SubOrder)

admin.site.register(Product)

admin.site.register(Label)

admin.site.register(Category)

admin.site.register(Order)

admin.site.register(Comment)

admin.site.register(Payment)
