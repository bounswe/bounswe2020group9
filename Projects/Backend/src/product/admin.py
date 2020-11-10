from django.contrib import admin

from product.models import Product,Order,Comment,ProductList
# Register your models here.

admin.site.register(Product)

admin.site.register(Order)

admin.site.register(Comment)

admin.site.register(ProductList)