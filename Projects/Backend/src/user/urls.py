from django.urls import path

from product.views import ListListAPIView
from .views import UserListAPIView, UserDetailAPIView, UserLoginAPIView, UserSignupAPIView, UserProfileAPIView, \
    VerificationView


urlpatterns = [
    path('', UserListAPIView.as_view(), name="user-list"),
    path('<int:id>/', UserDetailAPIView.as_view(), name="user-detail"),
    path('<int:id>/', UserDetailAPIView.as_view(), name="vendor-detail"),
    path('<int:id>/list/', ListListAPIView().as_view(), name="user-list-list"), #GET(if not private) # TODO return public lists of user, if user is token user, also return private lists. Do not return cart/alerted list
    # path('<int:id>/list/<int:list_id>/', ListListAPIView().as_view(), name="user-list-detail"), #GET(if not private), POST(same user), PUT(same user), DELETE(same user) # TODO return specific list of user, if private, check user is token user
    # path('<int:id>/list/cart/', ListListAPIView().as_view(), name="user-list-cart"), #GET(private) # TODO return cart of user, note it is private
    # path('<int:id>/list/alerted_list/', ListListAPIView().as_view(), name="user-list-alerted_list"), #GET(private) # TODO return alerted list of user, note it is private
    # path('<int:id>/list/<int:list_id>/<int:product_id>', ListListAPIView().as_view(), name="user-list-add"), POST(private), DELETE(private) # TODO add/remove product to/from list
    path('login/', UserLoginAPIView.as_view()),
    path('signup/', UserSignupAPIView.as_view()),
    path('profile/', UserProfileAPIView.as_view()),
    path('activate/<uidb64>/', VerificationView.as_view(), name="activate"),
]
