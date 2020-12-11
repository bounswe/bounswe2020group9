from django.test import TestCase, Client
from .functions import create_user
from product.functions import create_product
from .models import Vendor


class UserTestCases(TestCase):
    def setup(self):
        create_user("Vendor", "vendor@test.com", "vendorpw")
        create_user("Customer", "customer1@test.com", "1customerpw")
        #create_user("Customer", "customer2@test.com", "2customerpw")
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

