from django.urls import path
from . import views
from .views import ProductDetailAPIView, ProductListAPIView

urlpatterns = [
    path('', ProductListAPIView.as_view(), name= "product-list"),
    path('<int:pk>', ProductDetailAPIView.as_view(), name= "product-detail"),
]
