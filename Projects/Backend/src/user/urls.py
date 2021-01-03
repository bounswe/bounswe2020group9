from django.urls import path

from product.views import ListListAPIView, ListDetailAPIView, CartAPIView, AlertListAPIView, AddProductToListAPIView
from .views import UserListAPIView, UserDetailAPIView, UserLoginAPIView, UserSignupAPIView, UserProfileAPIView, \
    VerificationView, CustomerListAPIView, VendorListAPIView, ResetPasswordView, ResetPasswordMailView, \
    GoogleUserAPIView, ResetPasswordProfileView

urlpatterns = [
    path('', UserListAPIView.as_view(), name="user-list"),
    path('customer/', CustomerListAPIView.as_view(), name="customer-list"),
    path('vendor/', VendorListAPIView.as_view(), name="vendor-list"),
    path('<int:id>/', UserDetailAPIView.as_view(), name="user-detail"),
    path('<int:id>/', UserDetailAPIView.as_view(), name="vendor-detail"),
    path('<int:id>/lists/', ListListAPIView().as_view(), name="user-list-list"),
    path('<int:id>/list/<int:list_id>/', ListDetailAPIView().as_view(), name="user-list-detail"),
    path('<int:id>/list/<int:list_id>/edit/', AddProductToListAPIView().as_view(), name="user-list-add"),
    path('cart/', CartAPIView().as_view(), name="user-cart"),
    path('<int:id>/alert_list/', AlertListAPIView().as_view(), name="user-list-alerted_list"),
    path('login/', UserLoginAPIView.as_view()),
    path('signup/', UserSignupAPIView.as_view()),
    path('profile/', UserProfileAPIView.as_view()),
    path('activate/<uidb64>/', VerificationView.as_view(), name="activate"),
    path('resetpwmail/', ResetPasswordMailView.as_view()),
    path('resetpw/<uidb64>/', ResetPasswordView.as_view(), name="resetpw"),
    path('resetpwprofile/', ResetPasswordProfileView.as_view()),
    path('googleuser/', GoogleUserAPIView.as_view()),
]
