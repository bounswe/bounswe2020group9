import json

from django.test import TestCase, Client

from .functions import create_user


class UserTestCases(TestCase):

    def setUp(self):
        """User.objects.create(user_type = "Vendor",username="vendor@test.com",password="vendorpw")
        User.objects.create(user_type = "Customer",username="customer1@test.com",password="1customerpw")
        User.objects.create(user_type = "Customer",username="customer2@test.com",password="2customerpw")
        """
        self.user1 = create_user("Vendor", "vendor@test.com", "vendorpw")
        self.user2 = create_user("Customer", "customer1@test.com", "1customerpw")
        self.user3 = create_user("Customer", "customer2@test.com", "2customerpw")
    """
    def test_user_list(self):
        client = Client()
        response = client.get("/api/user/")
        response = json.loads(response.content)
        self.assertEqual("vendor@test.com", response[0]["email"])
        self.assertEqual("customer1@test.com", response[1]["email"])

    def test_customer_list(self):
        client = Client()
        response = client.get("/api/user/customer/")
        response = json.loads(response.content)
        self.assertEqual("customer1@test.com", response[0]["email"])

    def test_vendor_list(self):
        client = Client()
        response = client.get("/api/user/vendor/")
        response = json.loads(response.content)
        self.assertEqual("vendor@test.com", response[0]["email"])

    def test_user_detail(self):
        client = Client()
        response = client.get("/api/user/2/")
        response = json.loads(response.content)
        self.assertEqual("customer1@test.com", response["email"])
        response = client.get("/api/user/5/")
        self.assertEqual(response.status_code, 400)
        response = client.get("/api/user/3/")
        self.assertEqual(response.status_code, 200)
        # put test

    def test_login(self):
        client = Client()
        response = client.post("/api/user/login/", {"username": "customer1@test.com", "password": "1customerpw"})
        response = json.loads(response.content)
        self.assertEqual(2, response["user_id"])
        #self.assertEqual("customer1@test.com", response["email"])
        #self.assertEqual("1customerpw", response["password"])
        response = client.post("/api/user/login/", {"username": "customer1@test.com", "password": "1customerpwa"})
        response = json.loads(response.content)
        self.assertEqual("Unable to log in with provided credentials.", response["non_field_errors"][0])
    
    def test_signup(self):
        client = Client()
        response = client.post("/api/user/signup/",
                               {"username": "customer3@test.com", "password": "3customerpw", "user_type": 1})
        response = json.loads(response.content)
        self.assertEqual("An mail has been sent to your email, please check it", response["message"])
        response = client.post("/api/user/signup/",
                               {"username": "customer3@test.com", "password": "3customerpw", "user_type": 1})
        response = json.loads(response.content)
        self.assertEqual("A user with that username already exists.", response["username"][0])
    
    def test_user_profile(self):
        client = Client()
        response = client.post("/api/user/login/",{"username":"customer1@test.com","password":"1customerpw"})
        response = json.loads(response.content)
        token = response["token"]
        t = "Token " + str(token)
        response = client.get("/api/user/profile/",HTTP_AUTHORIZATION=t)
        response = json.loads(response.content)
        self.assertEqual("customer1@test.com",response["email"])
        response = client.put("/api/user/profile/",{"first_name":"test","last_name":"customer"},HTTP_AUTHORIZATION=t)
        response = json.loads(response.content)
        print(response)
        self.assertEqual("test",response["first_name"])"""
