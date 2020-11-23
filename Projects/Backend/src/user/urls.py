from django.urls import path
from .views import UserListAPIView,UserDetailAPIView,UserLoginAPIView,UserSignupAPIView


urlpatterns = [
    path('',UserListAPIView.as_view(), name="user-list"),
    path('<int:id>/', UserDetailAPIView.as_view(), name="user-detail"),
    path('login/',UserLoginAPIView.as_view()),
    path('signup/',UserSignupAPIView.as_view()),
]