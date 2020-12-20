from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated



from .models import Location
from .serializers import LocationSerializer


class LocationListAPIView(APIView):

    def get(self, request):
        location = Location.objects.all()
        serializer = LocationSerializer(location, many=True)

        return Response(serializer.data)

    def post(self, request):
        serializer = LocationSerializer(data=request.data)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class LocationDetailAPIView(APIView):

    def get_location(self, id):
        try:
            return Location.objects.get(id=id)

        except Location.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

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

class UserLocationListAPIView(APIView):

    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request):
        try:
            user_id = request.user.id
        except:
            return Response({"message": "Token is not valid."}, status=status.HTTP_401_UNAUTHORIZED)

        try:
            locations = Location.objects.filter(user=user_id)
        except:
            return Response(status=status.HTTP_204_NO_CONTENT)

        parent = LocationDetailAPIView()
        serializers = []
        for location in locations:
            location = parent.get_location(location.id)
            serializers.append(LocationSerializer(location).data)
        
        return Response(serializers)

    def post(self, request):
        try:
            user_id = request.user.id
        except:
            return Response({"message": "Token is not valid."}, status=status.HTTP_401_UNAUTHORIZED)

        serializer = LocationSerializer(data=request.data)

        if serializer.is_valid():
            if serializer.validated_data['user'].id == user_id:
                serializer.save()
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            else:
                return Response({"message": "Token and user id didn't match"}, status=status.HTTP_401_UNAUTHORIZED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)



class UserLocationDetailAPIView(APIView):

    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def put(self, request, id):
        try:
            user_id = request.user.id
        except:
            return Response({"message": "Token is not valid."}, status=status.HTTP_401_UNAUTHORIZED)

        serializer = LocationSerializer(data=request.data)

        if serializer.is_valid():
            if serializer.validated_data['user'].id == user_id:
                parent = LocationDetailAPIView()
                return parent.put(request, id)
            else:
                return Response({"message": "Token and user id didn't match"}, status=status.HTTP_401_UNAUTHORIZED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        

    def delete(self, request, id):
        try:
            user_id = request.user.id
        except:
            return Response({"message": "Token is not valid."}, status=status.HTTP_401_UNAUTHORIZED)

        try:
            location = Location.objects.get(id=id)

        except Location.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

        if location.user.id == user_id:
            location.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        return Response({"message": "Token and user id didn't match"}, status=status.HTTP_401_UNAUTHORIZED) 

