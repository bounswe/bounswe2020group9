from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import User
from .serializers import UserSerializer

from rest_framework.authtoken.models import Token

from django.contrib.auth.hashers import make_password


class UserListAPIView(APIView):

    def get(self, request):
        customers = User.objects.all()
        serializer = UserSerializer(customers, many=True)

        return Response(serializer.data)

    def post(self, request):
        # request.data['password'] = make_password(request.data['password'])
        serializer = UserSerializer(data=request.data)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class UserDetailAPIView(APIView):

    def get_user(self, id):
        try:
            return User.objects.get(id=id)

        except User.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

    def get(self, request, id):
        user = self.get_user(id)
        serializer = UserSerializer(user)
        return Response(serializer.data)

    def put(self, request, id):
        user = self.get_user(id)
        # request.data['password'] = make_password(request.data['password'])
        serializer = UserSerializer(user, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, id):
        user = self.get_user(id)
        user.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class UserLoginAPIView(APIView):

    def post(self, request):
        username = request.data["username"]
        password = request.data["password"]
        #user = authenticate(username=username, password=password)
        user = User.objects.filter(username=username)
        
        if len(user)==1:
            if user[0].password==password:
                #token, created = Token.objects.get_or_create(user=user)
                return Response(user[0].id, status=status.HTTP_202_ACCEPTED)
            else:
                return Response(
                    {
                        'message': 'Password is wrong.'
                    },
                    status=status.HTTP_401_UNAUTHORIZED)
        else:
            return Response(
                {
                    'message': 'User not found.'
                },
                status=status.HTTP_404_NOT_FOUND)