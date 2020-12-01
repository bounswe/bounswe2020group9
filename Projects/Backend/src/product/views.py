from django.http import HttpResponse, Http404
from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.status import HTTP_201_CREATED, HTTP_400_BAD_REQUEST, HTTP_404_NOT_FOUND, HTTP_204_NO_CONTENT
from rest_framework.views import APIView

from product.models import Product, ProductList
from product.serializers import ProductSerializer


# Create your views here.


class ProductListAPIView(APIView):

    def get(self, request):
        products = Product.objects.all()
        serializer = ProductSerializer(products, many=True, context={'request': request})
        return Response(serializer.data)

    def post(self, request):
        serializer = ProductSerializer(data=request.data)
        if serializer.is_valid():
            file = request.data['file']
            image = Product.objects.create(image=file)
            serializer.save()
            return Response(serializer.data, status=HTTP_201_CREATED)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)


class ProductDetailAPIView(APIView):

    def get_product(self, id):
        try:
            return Product.objects.get(id=id)
        except Product.DoesNotExist:
            return HttpResponse("product id "+ str(id) + " not found", status=HTTP_404_NOT_FOUND)

    def get(self, request, id):
        product = self.get_product(id)
        serializer = ProductSerializer(product)
        try:
            return Response(serializer.data)
        except:
            return HttpResponse("product id "+ str(id) + " not found", status=HTTP_404_NOT_FOUND)

    def put(self, request, id):
        product = self.get_product(id)
        serializer = ProductSerializer(product, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)

    def delete(self, request, id):
        product = self.get_product(id)
        product.delete()
        return Response("product id "+ str(id) + " deleted", status=HTTP_204_NO_CONTENT)


class ListListAPIView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get_list_list(self, user_id):
        try:
            return ProductList.objects.filter()
        except:
            raise Http404

    def check_id_valid(self, id, user_id):

        return id is user_id

    def get(self, request, id):
        if self.check_id_valid(id, request.user.id):
            return Response({"message":"unauthorized"}, status=status.HTTP_401_UNAUTHORIZED)
        products = self.get_list_list(id)
        serializer = ProductSerializer(products, many=True, context={'request': request})
        return Response(serializer.data)
