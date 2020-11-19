
from django.contrib import admin
from django.urls import path, include


urlpatterns = [
    path('', include("product.urls")),
    path('admin/', admin.site.urls),
    path('api/product/', include("product.urls")),
    path('api/location/', include("location.urls")),
]
