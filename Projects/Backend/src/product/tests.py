from django.test import TestCase, Client

from user.functions import create_user
from user.models import Vendor
from .functions import create_product, delete_product


# Create your tests here.


class ProductTestCase(TestCase):
    def setUp(self):
        vendor = create_user("Vendor", "vendor@test.com", "vendorpw")
        create_user("Customer", "customer@test.com", "1customerpw")
        create_product("myphone 9", "maple", 999, vendor.pk, 49)

    def test_get_product_list(self):
        client = Client()
        response = client.get("/api/product/")
        self.assertEqual(response.status_code, 200)

    def test_get_product_details(self):
        client = Client()
        vendor = Vendor.objects.get(pk=1)
        response1 = client.get("/api/product/1/")
        self.assertEqual(response1.status_code, 200)
        product2 = create_product("myphone 9", "maple", 999, vendor.pk, 49)
        response2 = client.get("/api/product/" + str(product2.id) + "/")
        self.assertEqual(response2.status_code, 200)
        delete_product(product2.id)
        response3 = client.get("/api/product/2/")
        self.assertEqual(response3.status_code, 404)
