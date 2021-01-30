from django.contrib.sites.shortcuts import get_current_site
from django.http import HttpResponse, Http404
from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.status import HTTP_201_CREATED, HTTP_400_BAD_REQUEST, HTTP_404_NOT_FOUND, HTTP_204_NO_CONTENT, \
    HTTP_202_ACCEPTED
from rest_framework.views import APIView
from django.utils import timezone


from message.models import Message, Conversation, Notification, Report
from message.serializers import MessageSerializer, NotificationSerializer, ConversationSerializer, ReportSerializer
from user.models import User, Customer, Vendor
from user.serializers import UserSerializer
from product.models import Delivery, Comment
from product.serializers import CommentSerializer

class AllMessages(APIView):
    def get(self, request):
        try:
            user_id = request.user.id
        except:
            return Response({"message": "Token is not valid."}, status=status.HTTP_401_UNAUTHORIZED)
        conversations = Conversation.objects.filter(user1_id=user_id) | Conversation.objects.filter(user2_id=user_id)
        conversations = conversations.order_by('-last_message_timestamp')
        number_of_unseen = 0
        responseList = []
        for conversation in conversations:
            d = {} 
            d["id"] = conversation.id
            is_user1 = conversation.user1.id == user_id
            messages = Message.objects.filter(conversation_id=conversation.id).order_by('timestamp')
            message = messages[len(messages)-1]
            d["last_message_body"] = message.body
            d["last_message_timestamp"] = message.timestamp
            d["am_I_user1"] = is_user1
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
            messageList = []
            unseen_message_counter = 0
            for message_ in messages:
                if is_user1 and not message_.is_visited_by_user1:
                    unseen_message_counter = unseen_message_counter + 1
                if not is_user1 and not message_.is_visited_by_user2:
                    unseen_message_counter = unseen_message_counter + 1
                messageList.append(MessageSerializer(message_).data)
            d["new_messages_of_conversation"] = unseen_message_counter
            d["messages"] = messageList
            d["id"] = conversation.id
            responseList.append(d)
        response = {}
        response["new_messages"] = number_of_unseen
        response["conversations"] = responseList
        return Response(response)



class Conversations(APIView):

    def get(self, request):
        try:
            user_id = request.user.id
        except:
            return Response({"message": "Token is not valid."}, status=status.HTTP_401_UNAUTHORIZED)
        conversations = Conversation.objects.filter(user1_id=user_id) | Conversation.objects.filter(user2_id=user_id)
        conversations = conversations.order_by('-last_message_timestamp')
        number_of_unseen = 0
        responseList = []
        for conversation in conversations:
            d = {} 
            d["id"] = conversation.id
            is_user1 = conversation.user1.id == user_id
            message = Message.objects.filter(conversation_id=conversation.id).order_by('-timestamp')[0]
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

            d["id"] = conversation.id
            responseList.append(d)
        response = {}
        response["new_messages"] = number_of_unseen
        response["conversations"] = responseList
        return Response(response)


class Messages(APIView):


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
            conversation.last_message_timestamp = timezone.now()
            conversation.save()
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
            res = NotificationSerializer(notification).data
            delivery_id = notification.delivery_id
            delivery = Delivery.objects.filter(id=delivery_id.id).values()
            res["delivery"] = delivery
            responseList.append(res)
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



#Admin calls
class AdminUserBan(APIView):

    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            user = request.user
        except:
            return Response({"message": "Token is not valid."}, status=status.HTTP_401_UNAUTHORIZED)

        if user.user_type != 3:
            return Response({"message": "You are not an admin."}, status=status.HTTP_401_UNAUTHORIZED)

        user_id = request.data["user_id"]
        banned_user = User.objects.get(id=user_id)
        banned_user.is_banned = True
        banned_user.save()
        return Response({"message": "User is banned."})


class Reports(APIView):

    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request):
        try:
            user = request.user
        except:
            return Response({"message": "Token is not valid."}, status=status.HTTP_401_UNAUTHORIZED)

        if user.user_type != 3:
            return Response({"message": "You are not an admin."}, status=status.HTTP_401_UNAUTHORIZED)

        reports  = Report.objects.all()
        reportList = []
        for report in reports:
            reportList.append(ReportSerializer(report).data)

        return Response(reportList)

    def post(self, request):
        try:
            user = request.user
        except:
            return Response({"message": "Token is not valid."}, status=status.HTTP_401_UNAUTHORIZED)

        report_type = int(request.data["report_type"])
        reported_id = int(request.data["reported_id"])
        available_report = Report.objects.filter(report_type=report_type, reported_user_id= reported_id, user=user) | Report.objects.filter(report_type=report_type, comment_id= reported_id, user=user)
        if len(available_report) > 0:
            return Response({"message": "You have already reported this issue."})
        report = Report()
        report.report_type = report_type
        report.user = user
        if report_type == 1:
            try:
                reported_user = User.objects.get(id=reported_id)
            except:
                return Response({"message": "Reported user is not valid."}, status=status.HTTP_400_BAD_REQUEST)
            report.reported_user = reported_user
        elif report_type == 2:
            try:
                reported_comment = Comment.objects.get(id=reported_id)
            except:
                return Response({"message": "Reported comment is not valid."}, status=status.HTTP_400_BAD_REQUEST)
            report.comment = reported_comment
        else:
            return Response({"message": "Report type is not valid."}, status=status.HTTP_400_BAD_REQUEST)
        report.save()
        return Response({"message": "Report is created."}, status=status.HTTP_201_CREATED) 

    def delete(self, request):
        try:
            user = request.user
        except:
            return Response({"message": "Token is not valid."}, status=status.HTTP_401_UNAUTHORIZED)

        if user.user_type != 3:
            return Response({"message": "You are not an admin."}, status=status.HTTP_401_UNAUTHORIZED)

        report_id = request.data["report_id"]
        try:
            report = Report.objects.get(id=report_id)
            report.delete()
        except:
            return Response({"message": "Report is not available."}, status=status.HTTP_400_BAD_REQUEST)
        return Response({"message": "Report is deleted."}, status=status.HTTP_202_ACCEPTED)




class AdminComments(APIView):

    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request):
        try:
            user = request.user
        except:
            return Response({"message": "Token is not valid."}, status=status.HTTP_401_UNAUTHORIZED)

        if user.user_type != 3:
            return Response({"message": "You are not an admin."}, status=status.HTTP_401_UNAUTHORIZED)

        comments = Comment.objects.all()
        commentList = []
        for comment in comments:
            commentList.append(CommentSerializer(comment).data)
        return Response(commentList)


    def delete(self, request):
        try:
            user = request.user
        except:
            return Response({"message": "Token is not valid."}, status=status.HTTP_401_UNAUTHORIZED)

        if user.user_type != 3:
            return Response({"message": "You are not an admin."}, status=status.HTTP_401_UNAUTHORIZED)

        comment_id = request.data["comment_id"]
        try:
            comment = Comment.objects.get(id=comment_id)
            comment.delete()
        except:
            return Response({"message": "Comment is not available."}, status=status.HTTP_400_BAD_REQUEST)
        return Response({"message": "Comment is deleted."}, status=status.HTTP_202_ACCEPTED)
