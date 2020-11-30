from django.http import Http404
from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import Location
from .serializers import LocationSerializer


class LocationListAPIView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request):
        location = Location.objects.filter(user=request.user.id)
        serializer = LocationSerializer(location, many=True)

        return Response(serializer.data)

    def post(self, request):
        serializer = LocationSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class LocationDetailAPIView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get_location(self, id):
        try:
            return Location.objects.get(id=id)

        except Location.DoesNotExist:
            raise Http404

    def get(self, request, id):
        location = self.get_location(id)
        serializer = LocationSerializer(location)
        return Response(serializer.data)

    def put(self, request, id):
        location = self.get_location(id)

        serializer = LocationSerializer(location, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, id):
        location = self.get_location(id)
        location.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class ProfileLocationListAPIView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request):
        parent = LocationListAPIView()
        if "user" in request.data and request.data["user"] is not request.user.id:
            return Response({"message":"unauthorized"}, status=status.HTTP_401_UNAUTHORIZED)
        return parent.get(request)

    def post(self, request):
        parent = LocationListAPIView()
        if "user" in request.data and request.data["user"] is not request.user.id:
            return Response({"message":"unauthorized"}, status=status.HTTP_401_UNAUTHORIZED)
        return parent.post(request)


class ProfileLocationDetailAPIView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get_location(self, id):
        try:
            return Location.objects.get(id=id)
        except Location.DoesNotExist:
            raise Http404

    def get(self, request, id):
        parent = LocationDetailAPIView()
        location = self.get_location(id)
        if location.user_id is not request.user.id:
            return Response({"message":"unauthorized"}, status=status.HTTP_401_UNAUTHORIZED)
        return parent.get(request, id)

    def put(self, request, id):
        parent = LocationDetailAPIView()
        location = self.get_location(id)
        if location.user_id is not request.user.id:
            return Response({"message":"unauthorized"}, status=status.HTTP_401_UNAUTHORIZED)
        if request.user.id is not request.data["user"]:
            return Response({"message":"cannot change user"}, status=status.HTTP_400_BAD_REQUEST)
        return parent.put(request, id)

    def delete(self, request, id):
        parent = LocationDetailAPIView()
        location = self.get_location(id)
        if location.user_id is not request.user.id:
            return Response({"message":"unauthorized"}, status=status.HTTP_401_UNAUTHORIZED)
        return parent.delete(request, id)