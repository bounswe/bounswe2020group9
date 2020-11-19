from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Location
from .serializers import LocationSerializer



class LocationListAPIView(APIView):

    def get(self,request):
        location = Location.objects.all()
        serializer = LocationSerializer(location,many=True)

        return Response(serializer.data)

    def post(self,request):


        serializer = LocationSerializer(data=request.data)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data,status=status.HTTP_201_CREATED)
        return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)

class LocationDetailAPIView(APIView):

    def get_location(self,id):
        try:
            return Location.objects.get(id=id)

        except Location.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

    def get(self,request,id):
        location = self.get_location(id)
        serializer = LocationSerializer(location)
        return Response(serializer.data)

    def put(self,request,id):
        location = self.get_location(id)

        serializer = LocationSerializer(location,data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)

    def delete(self,request,id):
        location = self.get_location(id)
        location.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
