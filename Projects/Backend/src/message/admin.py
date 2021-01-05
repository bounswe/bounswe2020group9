from django.contrib import admin

# Register your models here.
from message.models import Conversation, Message, Notification

admin.site.register(Conversation)

admin.site.register(Message)

admin.site.register(Notification)
