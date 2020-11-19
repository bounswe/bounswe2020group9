from django.urls import path
from .views import LocationDetailAPIView, LocationListAPIView

urlpatterns = [
    path('',LocationListAPIView.as_view()),
    path('<int:id>/',LocationDetailAPIView.as_view()),
]
