from django.urls import path

from product.views import ListListAPIView, ListDetailAPIView, CartAPIView, AlertListAPIView, AddProductToListAPIView
from .views import UserListAPIView, UserDetailAPIView, UserLoginAPIView, UserSignupAPIView, UserProfileAPIView, \
    VerificationView, CustomerListAPIView, VendorListAPIView

urlpatterns = [
    path('', UserListAPIView.as_view(), name="user-list"),
    path('customer/', CustomerListAPIView.as_view(), name="customer-list"),
    path('vendor/', VendorListAPIView.as_view(), name="vendor-list"),
    path('<int:id>/', UserDetailAPIView.as_view(), name="user-detail"),
    path('<int:id>/', UserDetailAPIView.as_view(), name="vendor-detail"),
    path('<int:id>/lists/', ListListAPIView().as_view(), name="user-list-list"), #GET(if not private) # TODO return public lists of user, if user is token user, also return private lists. Do not return cart/alerted list
    path('<int:id>/list/<int:list_id>/', ListDetailAPIView().as_view(), name="user-list-detail"), #GET(if not private), POST(same user), PUT(same user), DELETE(same user) # TODO return specific list of user, if private, check user is token user
    path('<int:id>/cart/', CartAPIView().as_view(), name="user-list-cart"), #GET(private) # TODO return cart of user, note it is private
    path('<int:id>/alerted_list/', AlertListAPIView().as_view(), name="user-list-alerted_list"), #GET(private) # TODO return alerted list of user, note it is private
    path('<int:id>/list/<int:list_id>/edit/', AddProductToListAPIView().as_view(), name="user-list-add"), # POST(private), DELETE(private) # TODO add/remove product to/from list
    path('login/', UserLoginAPIView.as_view()),
    path('signup/', UserSignupAPIView.as_view()),
    path('profile/', UserProfileAPIView.as_view()),
    path('activate/<uidb64>/', VerificationView.as_view(), name="activate"),
]
