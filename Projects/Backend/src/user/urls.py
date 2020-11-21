from django.urls import path
from .views import UserListAPIView,UserDetailAPIView,UserLoginAPIView

urlpatterns = [
    path('',UserListAPIView.as_view(), name= "user-list"),
    path('<int:id>/',UserDetailAPIView.as_view(), name= "user-detail"),
    path('signin',UserLoginAPIView.as_view(), name= "sign-in"),
]