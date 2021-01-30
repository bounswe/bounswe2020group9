from django.db import models
from django.utils import timezone

from user.models import User
from product.models import Delivery

# Admin imports
from product.models import Comment


# Conversation is a list of Messages between 2 Users
class Conversation(models.Model):
    user1 = models.ForeignKey(User, related_name="user1", on_delete=models.CASCADE)
    user2 = models.ForeignKey(User, related_name="user2", on_delete=models.CASCADE)
    last_message_timestamp = models.DateTimeField(default=timezone.now)


# One body of message that has been sent in a Conversation
class Message(models.Model):
    timestamp = models.DateTimeField(default=timezone.now)
    conversation = models.ForeignKey(Conversation, on_delete=models.CASCADE)
    body = models.CharField(max_length=255)
    is_user1 = models.BooleanField(default=True)
    is_visited_by_user1 = models.BooleanField(default=False)
    is_visited_by_user2 = models.BooleanField(default=False)


class Notification(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    body = models.CharField(max_length=255)
    timestamp = models.DateTimeField(default=timezone.now)
    type = models.CharField(max_length=255)
    delivery_id = models.ForeignKey(Delivery, on_delete=models.CASCADE, null=True, default=None)
    is_visited = models.BooleanField(default=False)


#Admin models
class Report(models.Model):
    REPORT_TYPES = (
        (1, "User"),
        (2, "Comment"),
    )
    report_type = models.PositiveSmallIntegerField(choices=REPORT_TYPES, default=1)
    timestamp = models.DateTimeField(default=timezone.now)
    user = models.ForeignKey(User, related_name="user", on_delete=models.CASCADE)
    reported_user = models.ForeignKey(User, related_name="reported_user", on_delete=models.CASCADE, null=True, default=None)
    comment = models.ForeignKey(Comment, on_delete=models.CASCADE, null=True, default=None)






