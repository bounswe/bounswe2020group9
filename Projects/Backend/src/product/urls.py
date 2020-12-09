from django.urls import path

from .views import ProductDetailAPIView, ProductListAPIView, ManageCartAPIView, UserCommentAPIView, CommentsOfProductAPIView, AddCommentAPIView, UpdateCommentAPIView

urlpatterns = [
    path('', ProductListAPIView.as_view(), name="product-list"),
    path('<int:id>/', ProductDetailAPIView.as_view(), name="product-detail"),
    path('<int:id>/cart/', ManageCartAPIView.as_view(), name="product-add-to-cart"),
    path('comment/<int:pid>/<int:uid>/', UserCommentAPIView.as_view(), name="user-comment"),
    path('comment/<int:pid>/', CommentsOfProductAPIView.as_view(), name="get-all-comments"),
    path('comment/update/<int:id>/', UpdateCommentAPIView.as_view(), name="update-comment"),
    path('comment/', AddCommentAPIView.as_view(), name="add-comments"), 
]
