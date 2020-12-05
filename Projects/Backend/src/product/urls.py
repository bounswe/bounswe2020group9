from django.urls import path

from .views import ProductDetailAPIView, ProductListAPIView, OrderListAPIView, OrderDetailAPIView

urlpatterns = [
    path('', ProductListAPIView.as_view(), name="product-list"),
    path('<int:id>/', ProductDetailAPIView.as_view(), name="product-detail"),
    path('order/', OrderListAPIView.as_view(), name="order-list"),
    path('order/<int:id>/', OrderDetailAPIView.as_view(), name="order-detail"),
]
