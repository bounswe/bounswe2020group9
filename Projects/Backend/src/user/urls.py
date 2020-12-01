from django.urls import path

from .views import UserListAPIView, UserDetailAPIView, UserLoginAPIView, UserSignupAPIView, UserProfileAPIView, \
    VerificationView, ResetPasswordView,ResetPasswordMailView

urlpatterns = [
    path('', UserListAPIView.as_view(), name="user-list"),
    path('<int:id>/', UserDetailAPIView.as_view(), name="user-detail"),
    path('<int:id>/', UserDetailAPIView.as_view(), name="vendor-detail"),
    path('login/', UserLoginAPIView.as_view()),
    path('signup/', UserSignupAPIView.as_view()),
    path('profile/', UserProfileAPIView.as_view()),
    path('activate/<uidb64>/', VerificationView.as_view(), name="activate"),
    path('resetpwmail/', ResetPasswordMailView.as_view()),
    path('resetpw/<uidb64>/', ResetPasswordView.as_view(), name="resetpw"),
]
