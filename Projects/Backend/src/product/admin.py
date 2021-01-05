from django.contrib import admin

from product.models import Product, Order, Comment, ProductList, Payment, Label, Category, SubOrder, SearchHistory

# Register your models here.

admin.site.register(Product)

admin.site.register(Comment)

admin.site.register(Label)

admin.site.register(Category)

admin.site.register(ProductList)

admin.site.register(SubOrder)

admin.site.register(Order)

admin.site.register(Payment)

admin.site.register(SearchHistory)
