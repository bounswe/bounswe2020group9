

from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.contrib.staticfiles.storage import staticfiles_storage
from django.urls import path, include
from django.views.generic import RedirectView

urlpatterns = [

    path('api/product/', include("product.urls")),
    path('api/location/', include("location.urls")),
    path('api/user/', include("user.urls")),
    path('admin/', admin.site.urls),

]
