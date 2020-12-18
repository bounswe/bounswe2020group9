from django.utils import timezone

from message.models import Notification
from product.models import Product, ProductList, Label, Category, Order, Comment, Payment
from user.models import Vendor, Customer, User
import requests


def create_product(name, brand, price, vendor_id, stock=0):
    vendor = Vendor.objects.get(pk=vendor_id)
    return vendor.products.create(name=name, brand=brand, price=price, stock=stock)


def delete_product(product_id):
    deleting_product = Product.objects.get(id=product_id)
    Product.delete(deleting_product)


def create_product_list(name, owner_id):
    customer = Customer.objects.get(pk=owner_id)
    return customer.productlist_set.create(name=name)


def delete_product_list(product_id):
    deleting_product_list = ProductList.objects.get(id=product_id)
    ProductList.delete((deleting_product_list))


def create_label(name):
    new_label = Label()
    new_label.name = name
    return new_label.save()


def add_label(product, label_name):
    product.labels.add(Label.objects.get(name=label_name))


def delete_label(name):
    deleting_label = Label.objects.get(name=name)
    Label.delete(deleting_label)


def create_category(name, parent_name):
    if parent_name is not None:
        parent_category = Category.objects.get(name=parent_name)
        return parent_category.category_set.create(name=name)
    else:
        # if category has no parent
        new_category = Category()
        new_category.name = name
        new_category.save()
        return new_category


def add_category(product, category_name):
    product.categories.add(Category.objects.get(name=category_name))


def delete_category(name):
    deleting_category = Category.objects.get(name=name)
    Category.delete(deleting_category)


def create_order(customer_id, product_id, delivery_time):
    customer = Customer.objects.get(pk=customer_id)
    product = Product.objects.get(pk=product_id)

    new_order = Order(customer=customer, product=product)
    new_order.timestamp = timezone.now()
    new_order.delivery_time = delivery_time
    new_order.save()
    return new_order


def delete_order(order_id):
    deleting_order = Order.objects.get(pk=order_id)
    Order.delete(deleting_order)


def create_notification(type, user_id, body):
    user = User.objects.get(id=user_id)
    new_notification = Notification(user=user)
    new_notification.type = type
    new_notification.body = body
    new_notification.save()
    return new_notification


def delete_notification(notification_id):
    deleting_notification = Notification.objects.get(pk=notification_id)
    Notification.delete(deleting_notification)


def create_comment(body, rating, customer_id, product_id):
    customer = Customer.objects.get(pk=customer_id)
    product = Product.objects.get(pk=product_id)

    new_comment = Comment(product=product, customer=customer)
    new_comment.timestamp = timezone.now()
    new_comment.body = body

    rating_types = {v: k for k, v in dict(new_comment.RATES).items()}
    new_comment.rating = rating_types[rating]

    # exit()
    # customer.comment_set.add(new_comment)

    # product.comment_set.get(new_comment)
    new_comment.save()
    return new_comment


def delete_comment(comment_id):
    deleting_comment = Comment.objects.get(pk=comment_id)
    Comment.delete(deleting_comment)


def create_payment(customer_id, card):
    card_id = card["number"]
    date_month = card["date_month"]
    date_year = card["date_year"]
    cvv = card["cvv"]

    customer = Customer.objects.get(pk=customer_id)

    new_payment = Payment(owner=customer)
    new_payment.card_id = card_id
    new_payment.date_month = date_month
    new_payment.date_year = date_year
    new_payment.cvv = cvv
    new_payment.save()
    return new_payment


def delete_payment(payment_id):
    deleting_payment = Payment.objects.get(pk=payment_id)
    Payment.delete(deleting_payment)

    
def search_product_db(word_array,word_searched):
    results = []
    results = results + list(Product.objects.filter(name__icontains = word_searched).values())
    results = results + list(Product.objects.filter(detail__icontains = word_searched).values())
    results = results + list(Product.objects.filter(brand__icontains = word_searched).values())
    print(results)
    for words in word_array:
        results = results + list(Product.objects.filter(name__icontains = words).values())
        results = results + list(Product.objects.filter(detail__icontains = words).values())
        results = results + list(Product.objects.filter(brand__icontains = word_searched).values())
    res_set = set(results)
    results = list(res_set)
    return results

def datamuse_call(word):
    result = []
    word_array = word.split()
    max_word = int(60/len(word_array))
    words_string = ""
    for i in range(len(word_array)):
        words_string+=word_array[i]
        if i != len(word_array)-1:
            words_string+="+"
    response = requests.get('https://api.datamuse.com/words?ml='+words_string+"&max="+str(max_word))
    response = response.json()
    for element in response:
        result.append(element["word"])
    for words in word_array:
        response = requests.get('https://api.datamuse.com/words?ml='+words+"&max="+str(max_word))
        response = response.json()
        for element in response:
            result.append(element["word"])
    res = set(result)
    return list(res)
