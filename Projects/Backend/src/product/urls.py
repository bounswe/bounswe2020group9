from django.urls import path

from .views import ProductDetailAPIView, ProductListAPIView, AddProductToCartAPIView

urlpatterns = [
    path('', ProductListAPIView.as_view(), name="product-list"),
    path('<int:id>/', ProductDetailAPIView.as_view(), name="product-detail"),
    path('<int:id>/', AddProductToCartAPIView.as_view(), name="product-add-to-cart"),
]
