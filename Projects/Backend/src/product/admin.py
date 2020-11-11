from django.contrib import admin

from product.models import Product,Order,Comment,ProductList,CartList,AlertedList,Categories,Labels
# Register your models here.

admin.site.register(Product)

admin.site.register(Order)

admin.site.register(Comment)

admin.site.register(ProductList)

admin.site.register(CartList)

admin.site.register(AlertedList)

admin.site.register(Categories)

admin.site.register(Labels)