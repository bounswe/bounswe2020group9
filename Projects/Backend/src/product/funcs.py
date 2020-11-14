from product.models import Product, ProductList, Label, Category
from user.models import Vendor, Customer


def create_product(name, price, vendor_id):
    vendor = Vendor.objects.get(pk=vendor_id)
    vendor.products.create(name=name, price=price)


def delete_product(product_id):
    deleting_product = Product.objects.get(id=product_id)
    Product.delete(deleting_product)


def create_product_list(name, owner_id):
    customer = Customer.objects.get(pk=owner_id)
    customer.productlist_set.create(name=name)


def delete_product_list(product_id):
    deleting_product_list = ProductList.objects.get(id=product_id)
    ProductList.delete((deleting_product_list))


def create_label(name):
    new_label = Label()
    new_label.name = name
    new_label.save()


def delete_label(name):
    deleting_label = Label.objects.get(name=name)
    Label.delete(deleting_label)


def create_category(name, parent_name):
    if parent_name is not None:
        parent_category = Category.objects.get(name=parent_name)
        parent_category.category_set.create(name=name)
    else:
        # if category has no parent
        new_category = Category()
        new_category.name = name
        new_category.save()


def delete_category(name):
    deleting_category = Category.objects.get(name=name)
    Category.delete(deleting_category)