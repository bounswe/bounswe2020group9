from django.contrib.sites.shortcuts import get_current_site
from django.http import HttpResponse, Http404
from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.status import HTTP_201_CREATED, HTTP_400_BAD_REQUEST, HTTP_404_NOT_FOUND, HTTP_204_NO_CONTENT, \
    HTTP_202_ACCEPTED
from rest_framework.views import APIView
from django.utils import timezone
from datetime import timedelta
from message.models import Notification
from product.functions import search_product_db, datamuse_call, filter_func, sort_func, calculate_rating
from product.models import Product, ProductList, SubOrder, Comment, Category, Payment,Delivery,Order
from product.serializers import ProductSerializer, ProductListSerializer, CommentSerializer, SubOrderSerializer, \
    SearchHistorySerializer, CategorySerializer, PaymentSerializer, DeliverySerializer
# Create your views here.
from user.models import User, Customer, Vendor
from location.models import Location
from user.serializers import UserSerializer
import datetime

class ProductListAPIView(APIView):

    def get(self, request):
        products = Product.objects.all()
        serializer = ProductSerializer(products, many=True, context={'request': request})
        return Response(serializer.data)

    def post(self, request):
        if not Vendor.objects.filter(user_id=request.user.id).exists():
            return Response({"message": "you must be logged in as a Vendor to add product"},
                            status=HTTP_400_BAD_REQUEST)
        serializer = ProductSerializer(data=request.data, context={'request': request})
        try:
            file = request.data['file']
            image = Product.objects.create(image=file)
        except:
            None
        if serializer.is_valid():
            if "category_id" in request.data:
                try:
                    category = Category.objects.get(id=request.data["category_id"])
                except:
                    return Response({"message": "no category with id: 'category_id' "},
                                    status=HTTP_400_BAD_REQUEST)
                serializer.save(vendor_id=self.request.user.id, category=category)
            else:
                serializer.save(vendor_id=self.request.user.id)
            return Response(serializer.data, status=HTTP_201_CREATED)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)


class ProductDetailAPIView(APIView):

    def get_product(self, id):
        try:
            return Product.objects.get(id=id)
        except Product.DoesNotExist:
            return HttpResponse("product id " + str(id) + " not found", status=HTTP_404_NOT_FOUND)

    def get(self, request, id):
        product = self.get_product(id)
        serializer = ProductSerializer(product)
        try:
            return Response(serializer.data)
        except:
            return HttpResponse("product id " + str(id) + " not found", status=HTTP_404_NOT_FOUND)

    def put(self, request, id):
        product = self.get_product(id)
        serializer = ProductSerializer(product, data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            if "category" in request.data:
                product = self.get_product(id)
                product.category = Category.objects.get(id=request.data["category"])
                product.save()
            elif "category_id" in request.data:
                product = self.get_product(id)
                product.category = Category.objects.get(id=request.data["category_id"])
                product.save()
            if "detail" in request.data:
                product = self.get_product(id)
                product.detail = request.data["detail"]
                product.save()
            serializer = ProductSerializer(product)
            return Response(serializer.data)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)

    def delete(self, request, id):
        product = Product.objects.filter(id=id)
        if not product.exists():
            return Response({"message": "product not found"}, status=HTTP_404_NOT_FOUND)
        product = product[0]
        if not product.vendor_id == request.user.id:
            return Response({"message": "you must be the owner to delete product"}, status=HTTP_400_BAD_REQUEST)
        product = self.get_product(id)
        product.delete()
        return Response({"message": "product id " + str(id) + " deleted"}, status=HTTP_204_NO_CONTENT)


# return public lists of user, if user is token user, also return private lists. Do not return cart/alerted list
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

    # GET(if not private)
    def get(self, request, id):
        if len(Customer.objects.filter(pk=id)) == 0:  # is user does not exist
            raise Http404
        product_lists = self.get_list_list(request, id)
        serializer = ProductListSerializer(product_lists, many=True, context={'request': request})
        return Response(serializer.data)

    # POST(same user)
    def post(self, request, id):
        if not self.is_user(request, id):
            return Response({"message": "bad request"}, status=status.HTTP_400_BAD_REQUEST)
        # error handling done above
        serializer = ProductListSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=HTTP_201_CREATED)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)


# return specific list of user, if private, check user is token user
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

    # GET(if not private)
    def get(self, request, id, list_id):
        if not self.check_user(request, id, list_id):
            return Response({"message": "bad request"}, status=status.HTTP_400_BAD_REQUEST)
        list = self.get_list(request, list_id)
        if not self.is_owner(request, id, list_id) and list.is_private:
            return Response({"message": "not allowed to access"}, status=status.HTTP_401_UNAUTHORIZED)
        # error handling done above
        serializer = ProductListSerializer(list, context={'request': request})
        return Response(serializer.data)

    # PUT(same user)
    def put(self, request, id, list_id):
        if not self.check_user(request, id, list_id):
            return Response({"message": "bad request"}, status=status.HTTP_400_BAD_REQUEST)
        if "is_private" in request.data and request.data["is_private"] not in ["true", "false"]:
            return Response({"is_private": ["return either 'true' or 'false'."]}, status=status.HTTP_400_BAD_REQUEST)
        list = self.get_list(request, list_id)
        if not self.is_owner(request, id, list_id):
            return Response({"message": "not allowed to access"}, status=status.HTTP_401_UNAUTHORIZED)
        # error handling done above
        try:
            if "name" in request.data:
                list.name = request.data["name"]
            if "is_private" in request.data:
                list.is_private = (request.data["is_private"] == "true")
            list.save()
            serializer = ProductListSerializer(list)
            return Response(serializer.data)
        except:
            return Response({"message": "bad request"}, status=HTTP_400_BAD_REQUEST)

    # DELETE(same user)
    def delete(self, request, id, list_id):
        if not self.check_user(request, id, list_id):
            return Response({"message": "bad request"}, status=status.HTTP_400_BAD_REQUEST)
        list = self.get_list(request, list_id)
        if not self.is_owner(request, id, list_id):
            return Response({"message": "not allowed to access"}, status=status.HTTP_401_UNAUTHORIZED)
        # error handling done above
        list.delete()
        return Response({"message": "list, id: " + str(list_id) + ", is deleted"}, status=HTTP_204_NO_CONTENT)


# return alerted list of user, note it is private
class AlertListAPIView(APIView):
    def get_alert_list(self, id):
        try:
            user = Customer.objects.get(user_id=id)
            return user.productlist_set.get_or_create(is_alert_list=True)[0]
        except:
            raise Http404

    def check_private_access(self, request, id):
        return id == request.user.id

    # GET(private)
    def get(self, request, id):
        if not self.check_private_access(request, id):
            return Response({"message": "not allowed to access"}, status=status.HTTP_401_UNAUTHORIZED)
        a_list = self.get_alert_list(id)
        serializer = ProductListSerializer(a_list, context={'request': request})
        return Response(serializer.data)


# add/remove product to/from list
class AddProductToListAPIView(APIView):
    def get_list(self, id):
        try:
            user = Customer.objects.get(user_id=id)
            return user.productlist_set.get_or_create()[0]
        except:
            raise Http404

    def check_authorization(self, request, id, list_id):
        return id == request.user.id and id == request.data[""]

    # POST(private)
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
            return Response({"message": "bad request: list_id"}, status=status.HTTP_400_BAD_REQUEST)
        if request.user.id != id:
            return Response({"message": "bad token"}, status=status.HTTP_400_BAD_REQUEST)
        if list.customer_id != customer.user_id:
            return Response({"message": "not allowed to access"}, status=status.HTTP_401_UNAUTHORIZED)
        # Error handling done
        if product not in list.product_set.all():
            list.product_set.add(product)
            serializer = ProductListSerializer(list, context={'request': request})
            return Response(serializer.data, status=HTTP_202_ACCEPTED)
        else:
            serializer = ProductListSerializer(list, context={'request': request})
            return Response(serializer.data, status=HTTP_204_NO_CONTENT)

    # DELETE(private)
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
            return Response(serializer.data, status=HTTP_202_ACCEPTED)
        else:
            serializer = ProductListSerializer(list, context={'request': request})
            return Response(serializer.data, status=HTTP_204_NO_CONTENT)


# return cart of user, note it is private
class CartAPIView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def add_or_create_sub_order(self, user_id, product_id, amount):
        try:
            subOrder = SubOrder.objects.get_or_create(customer_id=user_id, product_id=product_id, purchased=False)[0]
        except:
            raise Http404
        subOrder.amount += amount
        subOrder.save()
        return subOrder

    def cart_serializer_response(self, request):
        try:
            user = Customer.objects.get(user_id=request.user.id)
            cart = user.suborder_set.filter(purchased=False)
        except:
            raise Http404
        serializer = SubOrderSerializer(cart, many=True, context={'request': request})
        return Response(serializer.data)

    # GET(private)
    def get(self, request):
        return self.cart_serializer_response(request)

    def post(self, request):
        try:
            self.add_or_create_sub_order(request.user.id, request.data["product_id"], request.data["amount"])
        except Http404:
            raise Http404
        except:
            return Response({"message": "bad request body, 'product_id' and 'amount' required"},
                            status=status.HTTP_400_BAD_REQUEST)
        return self.cart_serializer_response(request)

    def put(self, request):
        try:
            subOrder = SubOrder.objects.get(customer_id=request.user.id, product_id=request.data["product_id"],
                                            purchased=False)
            subOrder.amount = request.data["amount"]
            subOrder.save()
        except:
            return Response({"message": "bad request body, 'product_id' and 'amount' required"},
                            status=status.HTTP_400_BAD_REQUEST)
        return self.cart_serializer_response(request)

    def delete(self, request):
        try:
            suborder = SubOrder.objects.filter(customer_id=request.user.id, product_id=request.data["product_id"],
                                               purchased=False)
            if suborder:
                suborder = suborder[0]
                suborder.delete()
            else:
                response = self.cart_serializer_response(request)
                response.status_code = HTTP_204_NO_CONTENT
                return response
        except:
            return Response({"message": "bad request body, 'product_id' required"}, status=status.HTTP_400_BAD_REQUEST)
        return self.cart_serializer_response(request)


class CategoryListAPIView(APIView):
    def get(self, request):
        categories = Category.objects.exclude(id=1)
        serializer = CategorySerializer(categories, many=True)
        return Response(serializer.data)


class AddCommentAPIView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            user_id = request.user.id
        except:
            return Response({"message": "Token is not valid."}, status=status.HTTP_401_UNAUTHORIZED)
        serializer = CommentSerializer(data=request.data)
        if serializer.is_valid():
            comment = Comment.objects.filter(product_id=serializer.validated_data['product'].id,
                                             customer_id=serializer.validated_data['customer'].user_id)
            if comment:
                return Response({"message": "A comment of you already exists"}, status=status.HTTP_400_BAD_REQUEST)
            if serializer.validated_data['customer'].user_id == user_id:
                # update the rating of the product
                product = serializer.validated_data['product']
                serializer.save()
                avg_rating = calculate_rating(product.id)
                product.rating = avg_rating
                product.save()
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            else:
                return Response({"message": "Token and user id didn't match"}, status=status.HTTP_401_UNAUTHORIZED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class UserCommentAPIView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, pid, uid):
        try:
            user_id = request.user.id
        except:
            return Response({"message": "Token is not valid."}, status=status.HTTP_401_UNAUTHORIZED)
        if uid == user_id:
            comment = Comment.objects.filter(product_id=pid, customer_id=uid)
            serializer = CommentSerializer(comment, many=True)
            return Response(serializer.data)
        return Response({"message": "Token and user id didn't match"}, status=status.HTTP_401_UNAUTHORIZED)


class UpdateCommentAPIView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def put(self, request, id):
        try:
            user_id = request.user.id
        except:
            return Response({"message": "Token is not valid."}, status=status.HTTP_401_UNAUTHORIZED)
        serializer = CommentSerializer(data=request.data)
        if serializer.is_valid():
            if serializer.validated_data['customer'].user_id == user_id:
                oldComment = Comment.objects.get(id=id)
                serializer = CommentSerializer(oldComment, data=request.data)
                if serializer.is_valid():
                    product = serializer.validated_data['product']
                    serializer.save()
                    avg_rating = calculate_rating(product.id)
                    product.rating = avg_rating
                    product.save()
                    return Response(serializer.data)
            else:
                return Response({"message": "Token and user id didn't match"}, status=status.HTTP_401_UNAUTHORIZED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, id):
        try:
            user_id = request.user.id
        except:
            return Response({"message": "Token is not valid."}, status=status.HTTP_401_UNAUTHORIZED)
        try:
            comment = Comment.objects.get(id=id)
            product = comment.product
        except Comment.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        if comment.customer.user_id == user_id:
            comment.delete()
            avg_rating = calculate_rating(product.id)
            product.rating = avg_rating
            product.save()
            return Response(status=status.HTTP_204_NO_CONTENT)
        return Response({"message": "Token and user id didn't match"}, status=status.HTTP_401_UNAUTHORIZED)


class CommentsOfProductAPIView(APIView):

    def get(self, request, pid):

        comments = Comment.objects.filter(product_id=pid)
        serializers = []
        for comment in comments:
            if comment.is_anonymous:
                comment.customer = None
                serializers.append(CommentSerializer(comment).data)
            else:
                serializer = {**CommentSerializer(comment).data,
                              **UserSerializer(User.objects.get(id=comment.customer.user_id)).data}
                serializers.append(serializer)
        return Response(serializers)


class CommentsOfUserAPIView(APIView):

    def get(self, request, id):
        
        comments = Comment.objects.filter(customer_id=id)
        serializers = []
        for comment in comments:
            if not comment.is_anonymous:
                serializer = CommentSerializer(comment).data
                serializers.append(serializer)
        return Response(serializers)


class VendorOrderView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]
    def get(self,request):
        user_id = request.user.id
        temp = list(Product.objects.filter(vendor_id=user_id).values())
        product_list = [temp[i]["id"] for i in range(len(temp))]
        products = list(Delivery.objects.filter(product_id__in=product_list).values())
        for i in range(len(products)):
            address_dict = list(Location.objects.filter(id=products[i]["location_id"]).values())[0]
            products[i]["delivery_address"] = address_dict
        result = sorted(products, key=lambda k: k["current_status"]) 
        return Response(result)
    def put(self,request):
        delivery_id = request.data["delivery_id"]
        delivery = Delivery.objects.get(id = delivery_id)
        if "status" in request.data:
            status1 = request.data["status"]
            if status1 != 4:
                delivery.current_status = status1
                st = ""
                if status1 == 1:
                    st = "Preparing"
                elif status1 ==2:
                    st= "On The Way"
                elif status1 == 3:
                    st = "Delivered"
                try:
                    body = "Your delivery with id "+ str(delivery_id) + " is now " +st
                    Notification.objects.create(user=User.objects.get(id=delivery.customer_id),body=body,timestamp=timezone.now())
                except:
                    pass
            else:
                return Response({"message" : "Vendor can not cancel order"},status=status.HTTP_400_BAD_REQUEST)
        if "delivery_time" in request.data:
            delivery_time1 = request.data["delivery_time"]
            a = datetime.datetime(delivery_time1["year"],delivery_time1["month"],delivery_time1["day"])
            delivery.delivery_time = a
            
        delivery.save()
        return Response({"message":"Updated Successfully"},status=status.HTTP_200_OK)
            
class OrderView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]
    def get(self,request):
        user_id = request.user.id
        result = []
        orders = Order.objects.filter(customer=user_id).values()
        for order in orders:
            deliveries = Delivery.objects.filter(order=order["id"]).values()
            delivery_list = []
            for delivery in deliveries:
                product_id = delivery["product_id"]
                product = Product.objects.get(id=product_id)
                delivery["vendor"] = product.vendor_id
                address_dict = Location.objects.filter(id=delivery["location_id"]).values()
                delivery["delivery_address"] = address_dict[0]
                delivery_list.append(delivery)
            order["deliveries"] = delivery_list
            result.append(order)
        result = sorted(result, key=lambda k: k["timestamp"],reverse=True) 
        return Response(result, status=status.HTTP_200_OK)
    def post(self,request):
        user_id = request.data["user_id"]
        deliveries = request.data["deliveries"]
        location_id = request.data["location"]
        user=Customer.objects.get(user_id=user_id)
        order = Order.objects.create(customer=user,timestamp=timezone.now())
        for delivery in deliveries:
            delivery["timestamp"] = timezone.now()
            delivery["customer"] = user_id
            delivery["order"] = order.id
            delivery["delivery_time"] = timezone.now() + timedelta(7)
            delivery["location"] = location_id
            product_id = delivery["product"]
            p1 = Product.objects.get(id = product_id)
            v1 = p1.vendor_id
            serializer = DeliverySerializer(data=delivery)
            if serializer.is_valid():
                serializer.save()
                try:
                    u1 = User.objects.get(id=v1)
                    body = str(u1.username) + " ordered " + str(p1.name) 
                    Notification.objects.create(user=u1,body=body,timestamp=timezone.now())
                    
                except:
                    pass
            else:
                return Response({"message":serializer.errors},status=status.HTTP_400_BAD_REQUEST)
        return Response(deliveries, status=status.HTTP_200_OK)   
    def put(self,request):
        delivery_id = request.data["delivery_id"]
        status1 = request.data["status"]
        if status1 == 4:
            delivery = Delivery.objects.get(id = delivery_id)
            delivery.current_status = 4
            delivery.save()
            return Response({"message":"Updated Successfully"},status=status.HTTP_200_OK)
        


class PaymentView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]
    def get(self,request):
        user_id = request.user.id
        cards = list(Payment.objects.filter(owner=user_id).values())
        return Response(cards, status=status.HTTP_200_OK)
    def post(self,request):
        serializer = PaymentSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return(Response(serializer.data,status=status.HTTP_200_OK))
        return(Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST))
    def put(self,request):
        card = Payment.objects.get(id=request.data["id"],owner=request.data["owner"])
        serializer = PaymentSerializer(card,data=request.data)
        if serializer.is_valid():
            serializer.save()
            return(Response(serializer.data,status=status.HTTP_200_OK))
        return(Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST))
    def delete(self,request):
        card = Payment.objects.get(id=request.data["id"],owner=request.data["owner"])
        card.delete()
        return Response({"message": "Card is deleted"},status=status.HTTP_204_NO_CONTENT)

class SearchAPIView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def post(self, request, filter_type, sort_type):
        domain = get_current_site(request).domain
        token = request.META.get('HTTP_AUTHORIZATION')[6:]
        if token != "57bcb0493429453fad027bc6552cc1b28d6df955":
            serializer = SearchHistorySerializer(data={"user": request.user.id, "searched": request.data["searched"]})
            if serializer.is_valid():
                serializer.save(user_id=request.user.id)
                word_list = datamuse_call(request.data["searched"])
                product_list = search_product_db(word_list, request.data["searched"])
                filter_type = str(filter_type)
                sort_type = str(sort_type)
                filter_types = filter_type.split("&")
                product_list = filter_func(filter_types, product_list)
                product_list = sort_func(sort_type, product_list)
                product_list2 = []
                for i in range(len(product_list)):
                    product = ProductSerializer(Product.objects.get(id=product_list[i]["id"])).data
                    product["picture"] = "http://" + domain + product["picture"]
                    product_list2.append(product)
                product_dict = {}
                product_dict["product_list"] = product_list2
                return Response(product_dict, status=status.HTTP_200_OK)
            return Response(serializer._errors, status=status.HTTP_400_BAD_REQUEST)
        else:
            word_list = datamuse_call(request.data["searched"])
            product_list = search_product_db(word_list, request.data["searched"])
            filter_type = str(filter_type)
            sort_type = str(sort_type)
            filter_types = filter_type.split("&")
            product_list = filter_func(filter_types, product_list)
            product_list = sort_func(sort_type, product_list)
            for i in range(len(product_list)):
                product = ProductSerializer(Product.objects.get(id=product_list[i]["id"])).data
                product["picture"] = "http://" + domain + product["picture"]
                product_list.append(product)
            product_dict = {}
            product_dict["product_list"] = product_list
            return Response(product_dict, status=status.HTTP_200_OK)
