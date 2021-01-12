from django.test import TestCase, Client
from .functions import create_user
from product.functions import create_product
from .models import Vendor,User,Customer
import json

class UserTestCases(TestCase):

    def setUp(self):
        """User.objects.create(user_type = "Vendor",username="vendor@test.com",password="vendorpw")
        User.objects.create(user_type = "Customer",username="customer1@test.com",password="1customerpw")
        User.objects.create(user_type = "Customer",username="customer2@test.com",password="2customerpw")
        """
        self.user1 = create_user("Vendor", "vendor@test.com", "vendorpw")
        self.user2 = create_user("Customer", "customer1@test.com", "1customerpw")
        self.user3 = create_user("Customer", "customer2@test.com", "2customerpw")
    def test_user_list(self):
        client = Client()
        response = client.get("/api/user/")
        response = json.loads(response.content)
        self.assertEqual("vendor@test.com",response[0]["email"])
        self.assertEqual("customer1@test.com",response[1]["email"])
    def test_customer_list(self):
        client = Client()
        response = client.get("/api/user/customer/")
        response = json.loads(response.content)
        self.assertEqual("customer1@test.com",response[0]["email"])
    def test_vendor_list(self):
        client = Client()
        response = client.get("/api/user/vendor/")
        response = json.loads(response.content)
        self.assertEqual("vendor@test.com",response[0]["email"])
    def test_user_detail(self):
        client = Client()
        response = client.get("/api/user/2/")
        response = json.loads(response.content)
        self.assertEqual("customer1@test.com",response["email"])
        response = client.get("/api/user/5/")
        self.assertEqual(response.status_code,400)
        response = client.get("/api/user/3/")
        self.assertEqual(response.status_code,200)
        # put test
    def test_login(self):
        client = Client()
        response = client.post("/api/user/login/",{"username":"customer1@test.com","password":"1customerpw"})
        response = json.loads(response.content)
        self.assertEqual(2,response["user_id"])
        self.assertEqual("customer1@test.com",response["email"])
        self.assertEqual("1customerpw",response["password"])
        response = client.post("/api/user/login/",{"username":"customer1@test.com","password":"1customerpwa"})
        response = json.loads(response.content)
        self.assertEqual("Unable to log in with provided credentials.",response["non_field_errors"][0])
    def test_signup(self):
        client = Client()
        response = client.post("/api/user/signup/",{"username":"customer3@test.com","password":"3customerpw","user_type":1})
        response = json.loads(response.content)
        self.assertEqual("An mail has been sent to your email, please check it",response["message"])
        response = client.post("/api/user/signup/",{"username":"customer3@test.com","password":"3customerpw","user_type":1})
        response = json.loads(response.content)
        self.assertEqual("A user with that username already exists.",response["username"][0])
    """def test_user_profile(self):
        client = Client()
        response = client.post("/api/user/login/",{"username":"customer1@test.com","password":"1customerpw"})
        response = json.loads(response.content)
        token = response["token"]
        #client.login(username='customer1@test.com', password='1customerpw')
        #client.credentials(HTTP_AUTHORIZATION='Token 245b909525d0af2b8ff9aa568962729ac7fb5b8d')
        u1=User.objects.get(email="customer1@test.com")
        #client.force_login(u1)
        response = client.get("/api/user/profile/",{"token":token})
        response = json.loads(response.content)
        print(response)
        self.assertEqual("customer1@test.com",response["email"])"""
