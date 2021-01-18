from django.urls import path

from .views import Messages, Conversations, GetConversation

urlpatterns = [
	path('', Messages.as_view(), name="messages"),
	path('conversations/', Conversations.as_view(), name="conversations" ),
	path('<int:id>/', GetConversation.as_view(), name="get-conversation"),
    
]
