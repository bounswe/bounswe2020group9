from django.urls import path

from .views import ProductDetailAPIView, ProductListAPIView, ManageCartAPIView,SearchAPIView


urlpatterns = [
    path('', ProductListAPIView.as_view(), name="product-list"),
    path('<int:id>/', ProductDetailAPIView.as_view(), name="product-detail"),
    path('<int:id>/cart/', ManageCartAPIView.as_view(), name="product-add-to-cart"),
    path('search/filter_type/sort_type/', SearchAPIView.as_view()),
]
