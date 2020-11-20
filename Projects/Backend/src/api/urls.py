
from django.contrib import admin
from django.urls import path, include


urlpatterns = [

    path('api/product/', include("product.urls")),
    path('api/location/', include("location.urls")),
    path('api/user/', include("user.urls")),
    path('admin/', admin.site.urls),
]
