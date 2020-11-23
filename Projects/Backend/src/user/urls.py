from django.urls import path
from .views import UserListAPIView,UserDetailAPIView,UserLoginAPIView,UserSignupAPIView,UserProfileAPIView


urlpatterns = [
    path('',UserListAPIView.as_view()),
    path('<int:id>/',UserDetailAPIView.as_view()),
    path('login/',UserLoginAPIView.as_view()),
    path('signup/',UserSignupAPIView.as_view()),
    path('profile/',UserProfileAPIView.as_view()),
]