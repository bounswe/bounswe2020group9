from django.utils import timezone

from product.models import Product, ProductList, Label, Category, Order, Notification, Comment, Payment
from user.models import Vendor, Customer, User


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

# TODO below is not tested yet, test if they work:


def create_order(customer_id, product_id, delivery_time):
    new_order = Order()
    new_order.timestamp = timezone.now()
    new_order.delivery_time = delivery_time
    new_order.save()

    customer = Customer.objects.get(id=customer_id)
    customer.order_set.add(new_order)

    product = Product.objects.get(id=product_id)
    product.order_set.add(new_order)


def delete_order(order_id):
    deleting_order = Order.objects.get(pk=order_id)
    Order.delete(deleting_order)


def create_notification(type, user_id, body):
    new_notification = Notification()
    new_notification.type = type
    new_notification.body = body
    new_notification.save()

    user = User.objects.get(id=user_id)
    user.notification_set.add(new_notification)


def delete_notification(notification_id):
    deleting_notification = Notification.objects.get(pk=notification_id)
    Notification.delete(deleting_notification)


def create_comment(body, rating, customer_id, product_id):
    new_comment = Comment()
    new_comment.timestamp = timezone.now()
    new_comment.body = body
    new_comment.rating = True
    new_comment.save()

    customer = Customer.objects.get(id=customer_id)
    customer.comment_set.add(new_comment)

    product = Product.objects.get(id=product_id)
    product.comment_set.get(new_comment)


def delete_comment(comment_id):
    deleting_comment = Comment.objects.get(pk=comment_id)
    Comment.delete(deleting_comment)


def create_payment(customer_id, card):
    card_id = card.id
    date_month = card.date_month
    date_year = card.date_year
    cvv = card.cvv

    new_payment = Payment()
    new_payment.card_id = card_id
    new_payment.date_month = date_month
    new_payment.date_year = date_year
    new_payment.cvv = cvv
    new_payment.save()

    customer = Customer.objects.get(customer_id)
    customer.payment_set.add(new_payment)


def delete_payment(payment_id):
    deleting_payment = Payment.objects.get(pk=payment_id)
    Payment.delete(deleting_payment)