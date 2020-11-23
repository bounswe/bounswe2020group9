from rest_framework.views import APIView
from rest_framework.response import Response
from django.http import Http404
from rest_framework import status
from .models import User
from .serializers import UserSerializer
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication
from rest_framework.authtoken.models import Token
from rest_framework.authtoken.views import ObtainAuthToken
from django.core.mail import EmailMessage
from django.shortcuts import render, redirect
from django.utils.encoding import force_bytes, force_text, DjangoUnicodeDecodeError
from django.utils.http import urlsafe_base64_decode, urlsafe_base64_encode
from django.contrib.sites.shortcuts import get_current_site
from django.urls import reverse



class UserListAPIView(APIView):

    #authentication_classes = [TokenAuthentication]
    #permission_classes = [IsAuthenticated]

    def get(self,request):
        customers = User.objects.all()
        serializer = UserSerializer(customers,many=True)
        return Response(serializer.data)

    def post(self,request):

        serializer = UserSerializer(data=request.data)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class UserDetailAPIView(APIView):

    #authentication_classes = [TokenAuthentication]
    #permission_classes = [IsAuthenticated]

    def get_user(self,id):

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
        serializer = UserSerializer(user,data=request.data)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data,status=status.HTTP_200_OK)
        return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)

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

            email = serializer.validated_data['username']
            serializer.save()
            user = User.objects.get(username = email)

            uidb64 = urlsafe_base64_encode(force_bytes(user.pk))

            domain = get_current_site(request).domain
            link = reverse('activate',kwargs={'uidb64':uidb64})
            
            activate_url = 'http://'+domain+link

            email_subject = 'Activate'
            email_body = 'Hi Please use this link to verify your account\n'+ activate_url
            email = EmailMessage(
                email_subject,
                email_body,
                'ibrahimorhanh@gmail.com',
                [email],
            )

            email.send(fail_silently =False)


            return Response(status=status.HTTP_201_CREATED)
        else:
            return Response(serializer._errors, status=status.HTTP_400_BAD_REQUEST)


class UserProfileAPIView(APIView):

    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self,request):
        parent = UserDetailAPIView()
        return parent.get(request,request.user.id)

    def put(self,request):
        parent = UserDetailAPIView()
        return parent.put(request,request.user.id)

    def delete(self,request):
        parent = UserDetailAPIView()
        return parent.delete(request,request.user.id)

class VerificationView(APIView):
    def get(self,request,uidb64):
        return render(request, 'myapp/index.html')

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