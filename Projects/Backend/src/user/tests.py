from django.test import TestCase, Client
from .functions import create_user
from product.functions import create_product
from .models import Vendor,User,Customer


class UserTestCases(TestCase):
    def setup(self):
        create_user("Vendor", "vendor@test.com", "vendorpw")
        create_user("Customer", "customer1@test.com", "1customerpw")
        create_user("Customer", "customer2@test.com", "2customerpw")
    def test_user_list(self):
        client = Client()
        response = client.get("/api/user/")
        self.assertEqual("vendor@test.com",response[0]["username"])
        self.assertEqual("customer1@test.com",response[1]["username"])
    def test_customer_list(self):
        client = Client()
        response = client.get("/api/user/customer/")
        self.assertEqual("customer1@test.com",response[0]["username"])
    def test_vendor_list(self):
        client = Client()
        response = client.get("/api/user/vendor/")
        self.assertEqual("vendor@test.com",response[0]["username"])
    def test_user_detail(self):
        client = Client()
        response = client.get("/api/user/2/")
        self.assertEqual("customer1@test.com",response[0]["username"])
        response = client.get("/api/user/5/")
        self.assertEqual(response.status_code,404)
        response = client.get("/api/user/3/")
        self.assertEqual(response.status_code,204)
        # put test
    def test_login(self):
        client = Client()
        response = client.post("/api/user/login/",{"username":"customer1@test.com","password":"1customerpw"})
        self.assertEqual(2,response["user_id"])
        self.assertEqual("customer1@test.com",response["email"])
        self.assertEqual("1customerpw",response["password"])
        response = client.post("/api/user/login/",{"username":"customer1@test.com","password":"1customerpwa"})
        self.assertEqual("Unable to log in with provided credentials.",response["non_field_errors"])
    def test_signup(self):
        client = Client()
        response = client.post("/api/user/signup/",{"username":"customer3@test.com","password":"3customerpw","user_type":1})
        self.assertEqual("An mail has been sent to your email, please check it",response["message"])
        response = client.post("/api/user/signup/",{"username":"customer3@test.com","password":"3customerpw","user_type":1})
        self.assertEqual("A user with that username already exists.",response["username"][0])

