from django.contrib import admin

# Register your models here.
from user.models import User, Customer, Vendor, Admin

admin.site.register(User)

admin.site.register(Customer)

admin.site.register(Vendor)

admin.site.register(Admin)