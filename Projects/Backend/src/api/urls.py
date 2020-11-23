"""
The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.conf import settings
from django.conf.urls import url
from django.conf.urls.static import static
from django.contrib import admin
from django.contrib.staticfiles.storage import staticfiles_storage
from django.urls import path, include
from django.views.generic import RedirectView
from django.views.static import serve
from rest_framework.urlpatterns import format_suffix_patterns

from api import views
from product.views import ProductDetailAPIView

urlpatterns = format_suffix_patterns([
    path('', views.api_root),
    path('admin/', admin.site.urls),
    path('api/', views.api_root),
    path('api/product/', include("product.urls")),
    path('api/user/', include("user.urls")),
    path('api/location/', include("location.urls")),
    path('favicon.ico', RedirectView.as_view(url=staticfiles_storage.url('images/favicon.ico'))),
    path('static/images/favicon.ico', RedirectView.as_view(url=staticfiles_storage.url('images/favicon.ico'))),
    #path('api/user/suzan_uskudarli', ProductDetailAPIView.as_view(), id=17), # vendor (databasede bulunsun ama kullanılmayacak)
    #path('api/user/1', ProductDetailAPIView.as_view(), pk=1), # customer (login olacak)
    #TODO name, surname, adres, puan(int), email, date_joined, last_login
]) + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)