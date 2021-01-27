from django.urls import path

from .views import LocationDetailAPIView, LocationListAPIView, UserLocationDetailAPIView, UserLocationListAPIView, VendorLocationDetailAPIView

urlpatterns = [
    path('', LocationListAPIView.as_view(), name="location-list"),
    path('<int:id>/', LocationDetailAPIView.as_view(), name="location-detail"),
    path('vendor/<int:id>/', VendorLocationDetailAPIView.as_view(), name="vendor-location"),
    path('byuser/<int:id>/', UserLocationDetailAPIView.as_view(), name="location-byuser"),
    path('byuser/', UserLocationListAPIView.as_view(), name="location-byuser"),
]
