from django.contrib.sites.shortcuts import get_current_site
from django.http import HttpResponse, Http404
from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.status import HTTP_201_CREATED, HTTP_400_BAD_REQUEST, HTTP_404_NOT_FOUND, HTTP_204_NO_CONTENT, \
    HTTP_202_ACCEPTED
from rest_framework.views import APIView


from message.models import Message, Conversation, Notification
from message.serializers import MessageSerializer, NotificationSerializer
from user.models import User, Customer, Vendor
from user.serializers import UserSerializer



class Conversations(APIView):

    def get(self, request):
        try:
            user_id = request.user.id
        except:
            return Response({"message": "Token is not valid."}, status=status.HTTP_401_UNAUTHORIZED)
        conversations = Conversation.objects.filter(user1_id=user_id) | Conversation.objects.filter(user2_id=user_id)
        number_of_unseen = 0
       	responseList = []
        for conversation in conversations:
        	d = {} 
        	is_user1 = conversation.user1.id == user_id
        	message = Message.objects.filter(conversation_id=conversation.id).order_by('-timestamp')[0]
        	d["id"] = conversation.id
        	d["last_message_body"] = message.body
        	d["last_message_timestamp"] = message.timestamp
        	if is_user1:
        		d["user_id"] = conversation.user2.id
        		d = {**d, **UserSerializer(conversation.user2).data}
        		d["is_visited"] = message.is_visited_by_user1
        		if not message.is_visited_by_user1:
        			number_of_unseen = number_of_unseen + 1
        	else:
        		d["user_id"] = conversation.user1.id
        		d = {**d, **UserSerializer(conversation.user1).data}
        		d["is_visited"] = message.is_visited_by_user2
        		if not message.is_visited_by_user2:
        			number_of_unseen = number_of_unseen + 1

        	responseList.append(d)
        response = {}
        response["new_messages"] = number_of_unseen
        response["conversations"] = responseList
        return Response(response)


class Messages(APIView):

    def get(self, request):
        try:
            user_id = request.user.id
        except:
            return Response({"message": "Token is not valid."}, status=status.HTTP_401_UNAUTHORIZED)
        
        return Response()

    def post(self, request):
        try:
            user_id = request.user.id
            user = request.user
        except:
            return Response({"message": "Token is not valid."}, status=status.HTTP_401_UNAUTHORIZED)

        receiver_username = request.data["receiver_username"]
        try:
            receiver_user_id = User.objects.filter(email=receiver_username)[0].id 
            receiver = User.objects.filter(email=receiver_username)[0]
        except:
            return Response({"message": "Reciver is not valid."}, status=status.HTTP_400_BAD_REQUEST)

        conversation = Conversation.objects.filter(user1_id=user_id, user2_id=receiver_user_id) | Conversation.objects.filter(user2_id=user_id, user1_id=receiver_user_id)
        if len(conversation):
            conversation = conversation[0]
        else:
            conversation = Conversation()
            conversation.user1=user
            conversation.user2=receiver
            conversation.save()

        is_user1 = conversation.user1 == user
        message = Message()
        message.is_user1 = is_user1
        message.conversation=conversation
        message.body = request.data["body"]
        if is_user1:
            message.is_visited_by_user1 = True
        else:
            message.is_visited_by_user2 = True
        message.save()
        return Response(status=status.HTTP_201_CREATED)


class GetConversation(APIView):

    def get(self, request, id):
        try:
            user_id = request.user.id
            user = request.user
        except:
            return Response({"message": "Token is not valid."}, status=status.HTTP_401_UNAUTHORIZED)

        try:
            conversation = Conversation.objects.get(id=id)
        except:
            return Response({"message": "Conversation is not valid."}, status=HTTP_404_NOT_FOUND)

        is_user1 = conversation.user1.id == user_id
        messages = Message.objects.filter(conversation_id=id).order_by('timestamp')
        messageList = []
        for message in messages:
        	serializer = MessageSerializer(message).data
        	if is_user1:
        		message.is_visited_by_user1 = True
        		other_user = conversation.user2
        		serializer["am_I_user1"] = True
        	else:
        		message.is_visited_by_user2 = True
        		other_user = conversation.user1
        		serializer["am_I_user1"] = False
        	message.save()
        	if is_user1 == message.is_user1:
        		serializer = {**serializer, **UserSerializer(user).data}
        		serializer["user_id"] = user.id
        	else:
        		serializer = {**serializer, **UserSerializer(other_user).data}
        		serializer["user_id"] = other_user.id
        	messageList.append(serializer)
        
        return Response(messageList)


class Notifications(APIView):

    def get(self, request):
        try:
            user_id = request.user.id
        except:
            return Response({"message": "Token is not valid."}, status=status.HTTP_401_UNAUTHORIZED)

        notifications = Notification.objects.filter(user_id=user_id)
        number_of_unseen = 0
        responseList = []
        for notification in notifications:
        	responseList.append(NotificationSerializer(notification).data)
        	if not notification.is_visited:
        		number_of_unseen = number_of_unseen + 1

        response = {}
        response["new_notifications"] = number_of_unseen
        response["notifications"] = responseList
        return Response(response)

    def post(self, request):
        try:
            user_id = request.user.id
        except:
            return Response({"message": "Token is not valid."}, status=status.HTTP_401_UNAUTHORIZED)

        notifications = Notification.objects.filter(user_id=user_id, is_visited=False)
        for notification in notifications:
        	notification.is_visited = True
        	notification.save()

        return Response(status=status.HTTP_202_ACCEPTED)



