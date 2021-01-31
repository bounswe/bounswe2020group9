from django.contrib.sites.shortcuts import get_current_site
from django.core.mail import EmailMessage
from django.utils import timezone
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_decode, urlsafe_base64_encode
from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.authtoken.models import Token
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.status import HTTP_404_NOT_FOUND
from rest_framework.views import APIView

from location.serializers import LocationSerializer
from product.models import Product
from product.serializers import ProductSerializer
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
            return Response(status=status.HTTP_400_BAD_REQUEST)

    def get(self, request, id):
        user = self.get_user(id)
        if type(user) == Response:
            return user
        else:
            serializer = UserSerializer(user)
            return Response(serializer.data)

    def put(self, request, id):

        user = self.get_user(id)
        serializer = UserSerializer(user, data=request.data, context={'request': request}, partial=True)

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
        if u.is_banned:
            return Response({"message": "User is banned."})
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


class GoogleUserAPIView(APIView):
    def post(self, request):
        request.data["password"] = "googlepassword"
        try:
            user = User.objects.get(username=request.data["username"])
        except:
            user = None
        if user == None:
            request.data["user_type"] = 1
            serializer = UserSerializer(data=request.data)
            if serializer.is_valid():
                # There error handling part might not be required, additional test is needed
                if not "user_type" in serializer.validated_data.keys():
                    return Response({"user_type": ["This field is required."]}, status=status.HTTP_400_BAD_REQUEST)
                if not "username" in serializer.validated_data.keys():
                    return Response({"username": ["This field is required."]}, status=status.HTTP_400_BAD_REQUEST)
                if not "password" in serializer.validated_data.keys():
                    return Response({"password": ["This field is required."]}, status=status.HTTP_400_BAD_REQUEST)
                serializer.save()
                user_temp = User.objects.get(username=request.data["username"])
                Customer.objects.create(user=user_temp)
                Token.objects.get(user=user_temp.id).delete()
                token = Token.objects.create(user=user_temp, key=request.data["token"])
                return Response(serializer.data, status=status.HTTP_200_OK)
            else:
                return Response(serializer._errors, status=status.HTTP_400_BAD_REQUEST)
        else:
            Token.objects.get(user=user.id).delete()
            try:
                token = Token.objects.create(user=user, key=request.data["token"])
                user.last_login = timezone.now()
                user.save()
                return Response({
                    'token': token.key,
                    'id': user.pk,
                    # 'email': user.email,
                    # 'password': password,
                    'user_type': user.user_type
                })
            except:
                return Response({"token": ["token is not valid"]}, status=status.HTTP_400_BAD_REQUEST)


class UserSignupAPIView(APIView):

    def post(self, request):
        user_field = ['id', 'username', 'password', 'email', 'first_name', 'last_name', 'date_joined', 'last_login',
                      'user_type', 'bazaar_point', 'company']
        user_dict = {}
        location_dict = {}
        for fields in request.data:
            if fields in user_field:
                user_dict[fields] = request.data[fields]
            else:
                location_dict[fields] = request.data[fields]
        serializer = UserSerializer(data=user_dict)

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

            if request.data['user_type'] == 2 or request.data['user_type'] == '2':
                if not "company" in request.data:
                    user.delete()
                    return Response({"company": ["This field is required."]}, status=status.HTTP_400_BAD_REQUEST)
                location_dict['user'] = user.id
                serializer2 = LocationSerializer(data=location_dict)
                if serializer2.is_valid():
                    serializer2.save()
                else:
                    user.delete()
                    return Response({"location": ["bad location request."]}, status=status.HTTP_400_BAD_REQUEST)

            user.is_active = False
            user.save()

            uidb64 = urlsafe_base64_encode(force_bytes(user.pk))

            domain = get_current_site(request).domain
            # link = reverse('activate', kwargs={'uidb64': uidb64})

            activate_url = 'http://' + "3.121.223.52:3000" + "/activate=" + str(uidb64)

            email_subject = 'Activate'
            email_body = 'Hi,\nPlease use this link to verify your account:\n' + activate_url
            email = EmailMessage(
                email_subject,
                email_body,
                'bazaar.app2451@gmail.com',
                [email],
            )
            try:
                email.send(fail_silently=False)
                return Response({"message": "An mail has been sent to your email, please check it"},
                                status=status.HTTP_201_CREATED)
            except:
                user.delete()
                return Response({"email": ["Couldn't send email"]}, status=status.HTTP_400_BAD_REQUEST)

        else:
            return Response(serializer._errors, status=status.HTTP_400_BAD_REQUEST)


# UserProfile returns UserDetail based on token
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
    def post(self, request):
        user = User.objects.get(username=request.data["username"])
        email = request.data["username"]
        uidb64 = urlsafe_base64_encode(force_bytes(user.pk))
        domain = get_current_site(request).domain
        # link = reverse('resetpw', kwargs={'uidb64': uidb64})
        reset_url = 'http://' + "3.121.223.52:3000" + "/resetpw=" + str(uidb64)
        email_subject = 'Reset Your Password'
        email_body = 'Hi,\nPlease use this link to reset your password:\n' + reset_url
        email = EmailMessage(
            email_subject,
            email_body,
            'bazaar.app2451@gmail.com',
            [email],
        )
        email.send(fail_silently=False)
        return Response({"message": "An mail has been sent to your email, please check it"},
                        status=status.HTTP_201_CREATED)


class ResetPasswordView(APIView):
    def get_object(self, request, uidb64, queryset=None):
        obj = User.objects.get(id=int(urlsafe_base64_decode(uidb64)))
        return obj

    def get(self, request, uidb64):
        return Response({"message": "true"})

    def post(self, request, uidb64):
        user_temp = self.get_object(request, uidb64)
        try:
            user_temp.set_password(request.data["new_password"])
            user_temp.save()
            response = {
                'status': 'success',
                'code': status.HTTP_200_OK,
                'message': 'Password updated successfully',
            }
        except:
            return Response({"message": "Couldn't reset password"}, status=status.HTTP_400_BAD_REQUEST)
        return Response(response, status=status.HTTP_201_CREATED)

      

class ResetPasswordProfileView(APIView):
    def post(self, request):
        user_temp = User.objects.get(id=request.data["user_id"])
        # Check old password
        if "old_password" in request.data.keys():
            if not user_temp.check_password(request.data["old_password"]):
                return Response({"old_password": ["Wrong password."]}, status=status.HTTP_400_BAD_REQUEST)
                # set_password also hashes the password that the user will get
        try:
            user_temp.set_password(request.data["new_password"])
            user_temp.save()
            response = {
                'status': 'success',
                'code': status.HTTP_200_OK,
                'message': 'Password updated successfully',
            }
        except:
            return Response({"message": "Couldn't reset password"}, status=status.HTTP_400_BAD_REQUEST)
        return Response(response, status=status.HTTP_201_CREATED)


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


class vendorProductListView(APIView):

    def get(self, request, vendor_id):
        vendor = Vendor.objects.filter(user_id=vendor_id)
        if not vendor.exists():
            return Response({"message": "vendor not found"}, status=HTTP_404_NOT_FOUND)

        product_list = Product.objects.filter(vendor_id=vendor_id)
        serializer = ProductSerializer(product_list, many=True, context={'request': request})
        return Response(serializer.data)
