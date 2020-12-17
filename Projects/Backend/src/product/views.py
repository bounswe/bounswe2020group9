from django.http import HttpResponse, Http404
from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated

from rest_framework.response import Response
from rest_framework.status import HTTP_201_CREATED, HTTP_400_BAD_REQUEST, HTTP_404_NOT_FOUND, HTTP_204_NO_CONTENT, \
    HTTP_200_OK, HTTP_202_ACCEPTED
from rest_framework.views import APIView

from product.models import Product, ProductList, SubOrder
from product.serializers import ProductSerializer, ProductListSerializer,SearchHistorySerializer
from product.functions import search_product_db,datamuse_call


# Create your views here.
from user.models import User, Customer


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
    # authentication_classes = [TokenAuthentication]
    # permission_classes = [IsAuthenticated]

    def is_user(self, request, id):
        return request.user.id is id

    def get_list_list(self, request, id):
        try:
            if self.is_user(request, id):
                product_lists = ProductList.objects.filter(customer_id=id, is_alert_list=False)
            else:
                product_lists = ProductList.objects.filter(customer_id=id, is_private=False, is_alert_list=False)
            return product_lists
        except:
            raise Http404

    def get(self, request, id):
        if len(Customer.objects.filter(pk=id)) == 0: # is user does not exist
            raise Http404
        product_lists = self.get_list_list(request, id)
        serializer = ProductListSerializer(product_lists, many=True, context={'request': request})
        return Response(serializer.data)

class ListDetailAPIView(APIView):

    def check_user(self, request, id, list_id):
        # checks if given input is valid, user_id is owner of the list_id
        try:
            list = ProductList.objects.get(id=list_id)
        except:
            raise Http404
        return list.customer_id is id

    def is_owner(self, request, id, list_id):
        # checks if token is owner of the list_id
        try:
            list = ProductList.objects.get(id=list_id)
        except:
            raise Http404
        return list.customer_id is request.user.id

    def get_list(self, request, list_id):
        try:
            return ProductList.objects.get(id=list_id)
        except:
            raise Http404

    def get(self, request, id, list_id):
        if not self.check_user(request, id, list_id):
            return Response({"message": "bad request"}, status=status.HTTP_400_BAD_REQUEST)
        list = self.get_list(request, list_id)
        if not self.is_owner(request, id, list_id) and list.is_private:
            return Response({"message": "not allowed to access"}, status=status.HTTP_401_UNAUTHORIZED)
        # error handling done above
        serializer = ProductListSerializer(list, context={'request': request})
        return Response(serializer.data)

    def post(self, request, id, list_id):
        if not self.check_user(request, id, list_id):
            return Response({"message": "bad request"}, status=status.HTTP_400_BAD_REQUEST)
        if not self.is_owner(request, id, list_id):
            return Response({"message": "not allowed to access"}, status=status.HTTP_401_UNAUTHORIZED)
        # error handling done above
        serializer = ProductListSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=HTTP_201_CREATED)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)

    def put(self, request, id, list_id):
        if not self.check_user(request, id, list_id):
            return Response({"message": "bad request"}, status=status.HTTP_400_BAD_REQUEST)
        list = self.get_list(request, list_id)
        if not self.is_owner(request, id, list_id):
            return Response({"message": "not allowed to access"}, status=status.HTTP_401_UNAUTHORIZED)
        # error handling done above
        serializer = ProductListSerializer(list, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)

    def delete(self, request, id, list_id):
        if not self.check_user(request, id, list_id):
            return Response({"message": "bad request"}, status=status.HTTP_400_BAD_REQUEST)
        list = self.get_list(request, list_id)
        if not self.is_owner(request, id, list_id):
            return Response({"message": "not allowed to access"}, status=status.HTTP_401_UNAUTHORIZED)
        # error handling done above
        list.delete()
        return Response({"message":"list, id: "+ str(list_id) + ", is deleted"}, status=HTTP_204_NO_CONTENT)


class CartAPIView(APIView):
    def get_cart(self, id):
        try:
            user = Customer.objects.get(user_id=id)
            return user.suborder_set.filter(is_alert_list=True)[0]
        except:
            raise Http404

    def check_private_access(self, request, id):
        return id == request.user.id

    def get(self, request, id):
        if not self.check_private_access(request, id):
            return Response({"message": "not allowed to access"}, status=status.HTTP_401_UNAUTHORIZED)
        cart = self.get_cart(id)
        serializer = ProductListSerializer(cart, context={'request': request})
        return Response(serializer.data)

class AlertListAPIView(APIView):
    def get_alert_list(self, id):
        try:
            user = Customer.objects.get(user_id=id)
            return user.productlist_set.get_or_create(is_alert_list=True)[0]
        except:
            raise Http404

    def check_private_access(self, request, id):
        return id == request.user.id

    def get(self, request, id):
        if not self.check_private_access(request, id):
            return Response({"message": "not allowed to access"}, status=status.HTTP_401_UNAUTHORIZED)
        a_list = self.get_alert_list(id)
        serializer = ProductListSerializer(a_list, context={'request': request})
        return Response(serializer.data)

class AddProductToListAPIView(APIView):
    def get_list(self, id):
        try:
            user = Customer.objects.get(user_id=id)
            return user.productlist_set.get_or_create()[0]
        except:
            raise Http404

    def check_authorization(self, request, id, list_id):
        return id == request.user.id and id == request.data[""]

    def post(self, request, id, list_id):
        try:
            product = Product.objects.get(id=request.data["product_id"])
        except:
            return Response({"message": "bad request: product"}, status=status.HTTP_400_BAD_REQUEST)
        try:
            customer = Customer.objects.get(user=id)
        except:
            return Response({"message": "bad request: customer"}, status=status.HTTP_400_BAD_REQUEST)
        try:
            list = ProductList.objects.get(id=list_id)
        except:
            return Response({"message": "bad request: list"}, status=status.HTTP_400_BAD_REQUEST)
        if request.user.id != id:
            return Response({"message": "bad token"}, status=status.HTTP_400_BAD_REQUEST)
        if list.customer_id != customer.user_id:
            return Response({"message": "not allowed to access"}, status=status.HTTP_401_UNAUTHORIZED)
        # Error handling done
        if product not in list.product_set.all():
            list.product_set.add(product)
            serializer = ProductListSerializer(list, context={'request': request})
            return Response(serializer.data, status= HTTP_202_ACCEPTED)
        else:
            serializer = ProductListSerializer(list, context={'request': request})
            return Response(serializer.data, status= HTTP_204_NO_CONTENT)

    def delete(self, request, id, list_id):
        try:
            product = Product.objects.get(id=request.data["product_id"])
        except:
            return Response({"message": "bad request: product"}, status=status.HTTP_400_BAD_REQUEST)
        try:
            customer = Customer.objects.get(user=id)
        except:
            return Response({"message": "bad request: customer"}, status=status.HTTP_400_BAD_REQUEST)
        try:
            list = ProductList.objects.get(id=list_id)
        except:
            return Response({"message": "bad request: list"}, status=status.HTTP_400_BAD_REQUEST)
        if request.user.id != id:
            return Response({"message": "bad token"}, status=status.HTTP_400_BAD_REQUEST)
        if list.customer_id != customer.user_id:
            return Response({"message": "not allowed to access"}, status=status.HTTP_401_UNAUTHORIZED)
        # Error handling done
        if product in list.product_set.all():
            list.product_set.remove(product)
            serializer = ProductListSerializer(list, context={'request': request})
            return Response(serializer.data, status= HTTP_202_ACCEPTED)
        else:
            serializer = ProductListSerializer(list, context={'request': request})
            return Response(serializer.data, status= HTTP_204_NO_CONTENT)

class ManageCartAPIView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get_product(self, product_id):
        try:
            product = Product.objects.get(id=product_id)
            return product
        except:
            raise Http404

    def create_sub_order(self, user_id, product_id, amount):
        subOrder = SubOrder.objects.get(customer_id=user_id, product_id=product_id, purchased=False)
        if subOrder:
            subOrder.amount += amount
            subOrder.save()
            return subOrder
        else:
            return SubOrder.objects.create(product_id=product_id, customer_id=user_id, amount=amount, purchased=False)

    def post(self, request, id):
        self.create_sub_order(request.user.id, id, request.data["amount"])
        cart = SubOrder.objects.filter(customer=request.user.id)
        serializer = ProductListSerializer(cart, context={'request': request})
        return Response(serializer.data)

    def put(self, request, id):
        subOrder = SubOrder.objects.get(customer_id=request.user.id, product_id=id)
        subOrder.amount = request.data["amount"]
        subOrder.save()
        cart = SubOrder.objects.filter(customer=request.user.id)
        serializer = ProductListSerializer(cart, context={'request': request})
        return Response(serializer.data)


    def delete(self, request, id):
        SubOrder.objects.get(customer_id=request.user.id, product_id=id).delete()
        cart = SubOrder.objects.filter(customer=request.user.id)
        serializer = ProductListSerializer(cart, context={'request': request})
        return Response(serializer.data)

class SearchAPIView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]
    def get(self,request):
        serializer = SearchHistorySerializer(data={"user":request.user.id,"searched":request.data["searched"]})
        if serializer.is_valid():
            serializer.save()
            word_list = datamuse_call(request.data["searched"])
            product_list = search_product_db(word_list,request.data["searched"])
            return Response(product_list, status=status.HTTP_200_OK)
        return Response(serializer._errors, status=status.HTTP_400_BAD_REQUEST)
