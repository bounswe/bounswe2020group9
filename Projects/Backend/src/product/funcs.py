from product.models import Product
from user.models import Vendor


def create_product(name, price, vendor_id):
    vendor = Vendor.objects.get(pk=vendor_id)
    vendor.products.create(name=name, price=price)

def delete_product(product_id):
    deleing_product = Product.objects.get(id=product_id)
    Product.delete(deleing_product)