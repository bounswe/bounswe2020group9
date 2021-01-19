from django.urls import path

from .views import Messages, Conversations, GetConversation, Notifications

urlpatterns = [
	path('', Messages.as_view(), name="messages"),
	path('conversations/', Conversations.as_view(), name="conversations" ),
	path('<int:id>/', GetConversation.as_view(), name="get-conversation"),
	path('notifications/', Notifications.as_view(), name="notifications" ),
    
]
