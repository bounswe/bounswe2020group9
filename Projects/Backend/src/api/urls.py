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

---

Main URL page, includes different url variations:

Redirects: "product", "user", "location", "message", "url" pages
Admin: Django Admin page, quite useful to reach/edit database
Images: Media(Images) links

"""

from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.contrib.staticfiles.storage import staticfiles_storage
from django.urls import path, include
from django.views.generic import RedirectView
from rest_framework.urlpatterns import format_suffix_patterns

from api import views

urlpatterns = format_suffix_patterns([
    path('', views.api_root),
    path('admin/', admin.site.urls),
    path('api/', views.api_root),
    path('api/product/', include("product.urls")),
    path('api/user/', include("user.urls")),
    path('api/location/', include("location.urls")),
    path('api/message/', include("message.urls")),
    path('favicon.ico', RedirectView.as_view(url=staticfiles_storage.url('images/favicon.ico'))),
    path('static/images/favicon.ico', RedirectView.as_view(url=staticfiles_storage.url('images/favicon.ico'))),
]) + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
