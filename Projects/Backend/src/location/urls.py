from django.urls import path

from .views import LocationDetailAPIView, LocationListAPIView, UserLocationDetailAPIView, UserLocationListAPIView

urlpatterns = [
    path('', LocationListAPIView.as_view(), name="location-list"),
    path('<int:id>/', LocationDetailAPIView.as_view(), name="location-detail"),

    path('byuser/<int:id>/', UserLocationDetailAPIView.as_view(), name="location-byuser"),
    path('byuser/', UserLocationListAPIView.as_view(), name="location-byuser"),
]
