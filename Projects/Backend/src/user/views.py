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


class UserListAPIView(APIView):

    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self,request):
        customers = User.objects.all()
        serializer = UserSerializer(customers,many=True)
        return Response(serializer.data)


    def post(self,request):

        serializer = UserSerializer(data=request.data)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data,status=status.HTTP_201_CREATED)
        return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)


class UserDetailAPIView(APIView):

    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get_user(self,id):
        try:
            return User.objects.get(id=id)
        except User.DoesNotExist:
            raise Http404

    def get(self,request,id):
        user = self.get_user(id)
        serializer = UserSerializer(user)
        return Response(serializer.data)

    def put(self,request,id):
        user = self.get_user(id)
        serializer = UserSerializer(user,data=request.data)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data,status=status.HTTP_200_OK)
        return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)

    def delete(self,request,id):
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
            serializer.save()
            return Response(status=status.HTTP_201_CREATED)
        else:
            return Response(serializer._errors, status=status.HTTP_400_BAD_REQUEST)