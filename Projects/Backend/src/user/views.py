from django.contrib.sites.shortcuts import get_current_site
from django.core.mail import EmailMessage
from django.http import Http404, HttpResponse
from django.urls import reverse
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_decode, urlsafe_base64_encode
from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.authtoken.models import Token
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from user.models import Customer, Admin, Vendor
from .models import User
from .serializers import UserSerializer


class UserListAPIView(APIView):

    # authentication_classes = [TokenAuthentication]
    # permission_classes = [IsAuthenticated]

    def get(self, request):
        customers = User.objects.all()
        serializer = UserSerializer(customers, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = UserSerializer(data=request.data)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class UserDetailAPIView(APIView):

    # authentication_classes = [TokenAuthentication]
    # permission_classes = [IsAuthenticated]

    def get_user(self, id):

        try:
            return User.objects.get(id=id)
        except User.DoesNotExist:
            raise Http404

    def get(self, request, id):
        user = self.get_user(id)
        serializer = UserSerializer(user)
        return Response(serializer.data)

    def put(self, request, id):

        user = self.get_user(id)
        serializer = UserSerializer(user, data=request.data)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, id):
        user = self.get_user(id)
        user.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class UserLoginAPIView(ObtainAuthToken):

    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data,
                                           context={'request': request})
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        password = serializer.validated_data['password']
        token, created = Token.objects.get_or_create(user=user)
        return Response({
            'token': token.key,
            'user_id': user.pk,
            'email': user.email,
            'password': password
        })


class UserSignupAPIView(APIView):

    def post(self, request):

        serializer = UserSerializer(data=request.data)

        if serializer.is_valid():
            if not "user_type" in serializer.validated_data.keys():
                return Response({"user_type": ["This field is required."]}, status=status.HTTP_400_BAD_REQUEST)
            email = serializer.validated_data['username']
            serializer.save()
            user = User.objects.get(username=email)
            user.is_active = False

            uidb64 = urlsafe_base64_encode(force_bytes(user.pk))

            domain = get_current_site(request).domain
            link = reverse('activate', kwargs={'uidb64': uidb64})

            activate_url = 'http://' + domain + link + '/'

            email_subject = 'Activate'
            email_body = 'Hi,\nPlease use this link to verify your account:\n' + activate_url
            email = EmailMessage(
                email_subject,
                email_body,
                'bazaar.app451@gmail.com',
                [email],
            )
            try:
                email.send(fail_silently=False)
            except Exception:
                user.delete()
                return Response({"username": ["Couldn't send email"]}, status=status.HTTP_400_BAD_REQUEST)
            return Response({"message": "Success: An mail has been sent to your email, please check it"},
                            status=status.HTTP_201_CREATED)
        else:
            return Response(serializer._errors, status=status.HTTP_400_BAD_REQUEST)


class UserProfileAPIView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request):
        parent = UserDetailAPIView()
        return parent.get(request, request.user.id)

    def put(self, request):
        parent = UserDetailAPIView()
        return parent.put(request, request.user.id)

    def delete(self, request):
        parent = UserDetailAPIView()
        return parent.delete(request, request.user.id)


class VerificationView(APIView):
    def get(self, request, uidb64):
        user = User.objects.get(id=int(urlsafe_base64_decode(uidb64)))
        user.is_active = True
        if user.user_type == 2:
            new_type = Vendor()
        elif user.user_type == 1:
            new_type = Customer()
        elif user.user_type == 3:
            new_type = Admin()
        else:
            print("ERROR")
            return
        new_type.user_id = user.id
        try:
            new_type.save()
        except:
            print("ERROR")
            user.delete()
            return HttpResponse(status=status.HTTP_400_BAD_REQUEST)
        return HttpResponse("Your Account, " + user.username + " has been activated", status=status.HTTP_200_OK)


"""    
class UserLoginAPIView(APIView):

    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data,
                                           context={'request': request})
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        token, created = Token.objects.get_or_create(user=user)
        return Response({
            'token': token.key,
            'user_id': user.pk,
            'email': user.email
        })


class UserSignupAPIView(APIView):

    def post(self,request):

        serializer = UserSerializer(data=request.data)

        if serializer.is_valid():
            serializer.save()
            return Response(status=status.HTTP_201_CREATED)
        else:
            return Response(
                {
                    'message': 'User not found.'
                },
                status=status.HTTP_404_NOT_FOUND)
"""
