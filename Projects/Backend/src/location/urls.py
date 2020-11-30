from django.urls import path

from .views import LocationDetailAPIView, LocationListAPIView, ProfileLocationListAPIView, ProfileLocationDetailAPIView

urlpatterns = [
    path('', ProfileLocationListAPIView.as_view(), name="location-list"),
    path('<int:id>/', ProfileLocationDetailAPIView.as_view(), name="location-detail"),

    # Commenting out them for now
    # path('', LocationListAPIView.as_view(), name="location-list"),
    # path('<int:id>/', LocationDetailAPIView.as_view(), name="location-detail"),
]
