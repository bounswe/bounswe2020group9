from django.urls import path
from .views import LocationDetailAPIView, LocationListAPIView

urlpatterns = [
    path('',LocationListAPIView.as_view(), name= "location-list"),
    path('<int:id>/',LocationDetailAPIView.as_view(), name= "location-detail"),
]

