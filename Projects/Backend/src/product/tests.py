from django.test import TestCase, Client

from user.functions import create_user
from user.models import Vendor
from .functions import create_product, delete_product
from .models import Category
import json
# Create your tests here.


class ProductTestCase(TestCase):
    def setUp(self):
        create_user("Customer", "customer@test.com", "1customerpw")
        vendor = create_user("Vendor", "vendor@test.com", "vendorpw")
        create_product("myphone 9", "maple", 999, vendor.pk, 49)
        Category.objects.create(name="electronics",parent_id="1")

    def test_get_product_list(self):
        client = Client()
        response = client.get("/api/product/")
        self.assertEqual(response.status_code, 200)
    
    def test_get_product_details(self):
        client = Client()
        vendor = Vendor.objects.get(pk=2)
        response1 = client.get("/api/product/1/")
        self.assertEqual(response1.status_code, 200)
        product2 = create_product("myphone 9", "maple", 999, vendor.pk, 49)
        response2 = client.get("/api/product/" + str(product2.id) + "/")
        self.assertEqual(response2.status_code, 200)
        delete_product(product2.id)
        response3 = client.get("/api/product/2/")
        self.assertEqual(response3.status_code, 404)
    def test_payment(self):
        client = Client()
        response = client.post("/api/user/login/",{"username":"customer@test.com","password":"1customerpw"})
        response = json.loads(response.content)
        token = response["token"]
        t = "Token " + str(token)
        response = client.post("/api/product/payment/",{
            "owner" : 1,"name_on_card":"customer","card_name":"card1","card_id":"1234567812345678",
            "date_month":"01","date_year":"25","cvv":"123"
            },HTTP_AUTHORIZATION=t)
        response = json.loads(response.content)
        self.assertEqual(response["card_name"],"card1")
        response = client.get("/api/product/payment/",HTTP_AUTHORIZATION=t)
        response = json.loads(response.content)
        self.assertEqual(response[0]["cvv"],"123")
        """response = client.delete("/api/product/payment/",json.dumps({"owner":1,"id":1}),HTTP_AUTHORIZATION=t)
        response = json.loads(response.content)
        print(response)"""
    def test_order(self):
        client = Client()
        response = client.post("/api/user/login/",{"username":"customer@test.com","password":"1customerpw"})
        response = json.loads(response.content)
        token = response["token"]
        t = "Token " + str(token)
        headers = {"HTTP_AUTHORIZATION":t}
        response = client.post("/api/product/order/",json.dumps({"user_id":1,"deliveries":[{"product":1,"amount":4}]}),headers=headers)
        response = json.loads(response.content)
        self.assertEqual(response[0]["product"],1)
        self.assertEqual(response[0]["oder"],1)
        