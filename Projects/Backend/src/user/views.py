from django.contrib.sites.shortcuts import get_current_site
from django.core.mail import EmailMessage
from django.http import Http404, HttpResponse
from django.urls import reverse
from django.utils import timezone
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
        users = User.objects.all()
        serializer = UserSerializer(users, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = UserSerializer(data=request.data)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class CustomerListAPIView(APIView):

    def get(self, request):
        customers = User.objects.filter(user_type=1)
        serializer = UserSerializer(customers, many=True)
        return Response(serializer.data)


class VendorListAPIView(APIView):

    def get(self, request):
        vendors = User.objects.filter(user_type=2)
        serializer = UserSerializer(vendors, many=True)
        return Response(serializer.data)



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
        u = User.objects.get(id=user.pk)
        u.last_login = timezone.now()
        u.save()
        password = serializer.validated_data['password']
        token, created = Token.objects.get_or_create(user=user)
        return Response({
            'token': token.key,
            'user_id': user.pk,
            # 'email': user.email,
            # 'password': password,
            'user_type': user.user_type
        })


class UserSignupAPIView(APIView):

    def post(self, request):

        serializer = UserSerializer(data=request.data)

        if serializer.is_valid():
            # There error handling part might not be required, additional test is needed
            if not "user_type" in serializer.validated_data.keys():
                return Response({"user_type": ["This field is required."]}, status=status.HTTP_400_BAD_REQUEST)
            if not "username" in serializer.validated_data.keys():
                return Response({"username": ["This field is required."]}, status=status.HTTP_400_BAD_REQUEST)
            if not "password" in serializer.validated_data.keys():
                return Response({"password": ["This field is required."]}, status=status.HTTP_400_BAD_REQUEST)
            email = serializer.validated_data['username']
            serializer.save()
            user = User.objects.get(username=email)
            user.is_active = False
            user.save()

            uidb64 = urlsafe_base64_encode(force_bytes(user.pk))

            domain = get_current_site(request).domain
            link = reverse('activate', kwargs={'uidb64': uidb64})

            activate_url = 'http://' + domain + link

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
            except:
                user.delete()
                return Response({"email": ["Couldn't send email"]}, status=status.HTTP_400_BAD_REQUEST)
            return Response({"message": "An mail has been sent to your email, please check it"},
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


class ResetPasswordMailView(APIView):
    def post(self,request):
        user = User.objects.get(username=request.data["username"])
        email = request.data["username"]
        uidb64 = urlsafe_base64_encode(force_bytes(user.pk))
        domain = get_current_site(request).domain
        link = reverse('resetpw', kwargs={'uidb64': uidb64})
        reset_url = 'http://' + domain + link
        email_subject = 'Reset Your Password'
        email_body = 'Hi,\nPlease use this link to reset your password:\n' + reset_url
        email = EmailMessage(
            email_subject,
            email_body,
            'bazaar.app451@gmail.com',
            [email],
        )
        email.send(fail_silently=False)
        return Response({"message": "An mail has been sent to your email, please check it"},
                    status=status.HTTP_201_CREATED)
class ResetPasswordView(APIView):
    def get_object(self,request,uidb64,queryset=None):
        obj = User.objects.get(id=int(urlsafe_base64_decode(uidb64)))
        return obj
    def get(self, request, uidb64):
        return Response({"message":"true"})
    def post(self, request, uidb64):
        user_temp = self.get_object(request,uidb64)
        # Check old password
        #if not user_temp.check_password(request.data["old_password"]):
            #return Response({"old_password": ["Wrong password."]}, status=status.HTTP_400_BAD_REQUEST)
            # set_password also hashes the password that the user will get
        try:
            user_temp.set_password(request.data["new_password"])
            user_temp.save()
            response = {
                'status': 'success',
                'code': status.HTTP_200_OK,
                'message': 'Password updated successfully',
                'data': []
            }
        except:
            return Response({"message":"Couldn't reset password"}, status=status.HTTP_400_BAD_REQUEST)
        return Response(response)

class VerificationView(APIView):
    def get(self, request, uidb64):
        try:
            user = User.objects.get(id=int(urlsafe_base64_decode(uidb64)))
        except:
            return Response({"url": ["bad verification url"]}, status=status.HTTP_400_BAD_REQUEST)
        if user.is_active:
            return Response({"user": ["user is already verified"]}, status=status.HTTP_400_BAD_REQUEST)
        if user.user_type == 2:
            new_type = Vendor()
        elif user.user_type == 1:
            new_type = Customer()
        elif user.user_type == 3:
            new_type = Admin()
        else:
            user.delete()
            return Response({"user_type": ["out of range"]}, status=status.HTTP_400_BAD_REQUEST)
        new_type.user_id = user.id
        try:
            new_type.save()
        except:
            user.delete()
            return Response({"user_type": ["cannot verify user_type"]}, status=status.HTTP_400_BAD_REQUEST)
        user.is_active = True
        user.save()
        return Response({"message": "Your Account, " + user.email + " has been activated"},
                            status=status.HTTP_200_OK)
