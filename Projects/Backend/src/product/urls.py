from django.urls import path

from user.views import vendorProductListView
from .views import ProductDetailAPIView, ProductListAPIView, UserCommentAPIView, CommentsOfProductAPIView, CommentsOfUserAPIView, \
    AddCommentAPIView, UpdateCommentAPIView, CategoryListAPIView, SearchAPIView, PaymentView, OrderView, \
    VendorOrderView

urlpatterns = [
    path('', ProductListAPIView.as_view(), name="product-list"),
    path('categories/', CategoryListAPIView.as_view(), name="category-list"),
    path('<int:id>/', ProductDetailAPIView.as_view(), name="product-detail"),
    path('comment/<int:pid>/<int:uid>/', UserCommentAPIView.as_view(), name="user-comment"),
    path('comment/<int:pid>/', CommentsOfProductAPIView.as_view(), name="get-all-comments"),
    path('comment/update/<int:id>/', UpdateCommentAPIView.as_view(), name="update-comment"),
    path('comment/user/<int:id>/all/', CommentsOfUserAPIView.as_view(), name="user-comments"),
    path('comment/', AddCommentAPIView.as_view(), name="add-comments"),
    path('vendor/<int:vendor_id>/', vendorProductListView.as_view(), name="vendor-products"),
    path('search/<str:filter_type>/<str:sort_type>/', SearchAPIView.as_view()),
    path('payment/',PaymentView.as_view(),name="payments"),
    path('order/',OrderView.as_view(),name="orders"),
    path('vendor_order/',VendorOrderView.as_view(),name="vendor_orders"),
]
