from django.db import models
from django.utils import timezone

from user.models import User
# Create your models here.


class Conversation(models.Model):
    user1 = models.ManyToManyField(User, related_name="user1")
    user2 = models.ManyToManyField(User, related_name="user2")


class Message(models.Model):
    timestamp = models.DateTimeField()
    conversation = models.ForeignKey(Conversation, on_delete=models.CASCADE)
    body = models.CharField(max_length=255)
    is_user1 = models.BooleanField(default=True)

class Notification(models.Model):
    user_id = models.ManyToManyField(User)
    body = models.CharField(max_length=255)
    timestamp = models.DateTimeField()
    notification_type = models.CharField(max_length=255)
