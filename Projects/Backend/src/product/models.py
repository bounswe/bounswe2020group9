\section{API Documentation}
\subsection{/api/}\label{api}
list of all other requests, useful for exploration:

\begin{verbatim}
> GET {{url}}/api/

->
{
    "user": "{{url}}/api/product/",
    "product": "{{url}}/api/user/",
    "location": "{{url}}/api/location/"
}
\end{verbatim}
\subsection{/api/product/}\label{apiproduct}
general information of all products :

\begin{verbatim}
> GET {{url}}/api/product/

->
[
    {
        "id": 3,
        "name": "Iphone XS 64GB",
        "brand": "Apple",
        "labels": [
            "10% off"
        ],
        "categories": [
            "Electronics"
        ],
        "price": 11211.52,
        "stock": 48,
        "sell_counter": 0,
        "rating": 0.0,
        "vendor": 2
    },
    ...
]
\end{verbatim}
\subsection{/api/product/$<id>$/}\label{apiproduct-1}
detailed information of the specified product:

\begin{verbatim}
> GET {{url}}/api/product/3/

->
{
    "id": 3,
    "name": "Iphone XS 64GB",from django.db import models
from django.utils import timezone

from user.models import Vendor, Customer, User


# Create your models here.


class ProductList(models.Model):
    name = models.CharField(max_length=255)
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE)
    is_private = models.BooleanField(default=True) # private can only seen by owner
    is_alert_list = models.BooleanField(default=False) # True if it is an alert list

    def __str__(self):
        return self.customer.user.username + " - " + self.name


def productImage(instance, filename):
    return '/'.join(['images', str(instance.name), filename])


def productImage(instance, filename):
    return '/'.join(['images', str(instance.name), filename])



class Category(models.Model):
    name = models.CharField(max_length=255, unique=True)
    parent = models.ForeignKey("self", default=0, on_delete=models.CASCADE, db_constraint=False)
    # products = models.ManyToManyField(Product, related_name="categories", blank=True)

    def __str__(self):
        return self.name

class Product(models.Model):
    name = models.CharField(max_length=255)
    detail = models.CharField(max_length=511, blank=True)
    # image = models.ImageField(upload_to ='pics')#option is to select media directory TODO need to implement
    brand = models.CharField(max_length=255)
    price = models.FloatField()
    stock = models.IntegerField(default=0)
    rating = models.FloatField(default=0)
    sell_counter = models.IntegerField(default=0)
    release_date = models.DateTimeField(default=timezone.now)
    picture = models.ImageField(upload_to=productImage, null=True, blank=True, default=None)
    category = models.ForeignKey(Category, on_delete=models.CASCADE, default=1)

    vendor = models.ForeignKey(
        Vendor,
        on_delete=models.CASCADE,
        related_name="products"
    )

    in_lists = models.ManyToManyField(ProductList, blank=True)

    def __str__(self):
        return self.name + " " + self.vendor.user.username


class SubOrder(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE)
    amount = models.IntegerField(default=1)
    purchased = models.BooleanField(default=False)


class Label(models.Model):
    name = models.CharField(max_length=255, unique=True)
    products = models.ManyToManyField(Product, related_name="labels", blank=True)

    def __str__(self):
        return self.name



class Order(models.Model):
    STATUS_TYPES = (
        (1, "Preparing"),
        (2, "On the Way"),
        (3, "Delivered"),
    )
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    sub_order = models.ForeignKey(SubOrder, on_delete=models.CASCADE)
    timestamp = models.DateTimeField()
    delivery_time = models.DateTimeField()
    current_status = models.PositiveSmallIntegerField(choices=STATUS_TYPES, default=1)


class Comment(models.Model):
    RATES = (
        (1, "Awful"),
        (2, "Bad"),
        (3, "Mediocre"),
        (4, "Good"),
        (5, "Excellent"),
    )
    timestamp = models.DateTimeField(auto_now_add=True)
    body = models.CharField(max_length=255)
    rating = models.PositiveSmallIntegerField(choices=RATES, default=5)
    is_anonymous = models.BooleanField(default=False)
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)


class Payment(models.Model):
    owner = models.ForeignKey(Customer, on_delete=models.CASCADE)
    # Below are cart info, TODO encrypt them
    card_id = models.CharField(max_length=16)
    date_month = models.CharField(max_length=2)
    date_year = models.CharField(max_length=2)
    cvv = models.CharField(max_length=3)

class SearchHistory(models.Model):
    user =  models.ForeignKey(User, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    "brand": "Apple",
    "labels": [
        "10% off"
    ],
    "categories": [
        "Electronics"
    ],
    "price": 11211.52,
    "stock": 48,
    "sell_counter": 0,
    "rating": 0.0,
    "vendor": 2
}
\end{verbatim}
\subsection{/api/user/}\label{apiuser}
list of all users:

\begin{verbatim}
> GET {{url}}/api/user/

-> [
    ...,
    {
        "id": 28,
        "email": "rajah.faolan@extraale.com",
        "first_name": "",
        "last_name": "",
        "date_joined": "2020-11-26T14:36:15.093169Z",
        "last_login": "2020-11-26T14:45:13.455166Z",
        "user_type": 1,
        "bazaar_point": 0
    },
    ...
]
\end{verbatim}
\subsection{/api/user/$<id>$/}\label{apiuser-1}
detailed description of the specified user:

\begin{verbatim}
> GET {{url}}/api/user/28/

-> {
        "id": 61,
        "email": "rajah.faolan@extraale.com",
        "first_name": "",
        "last_name": "",
        "date_joined": "2020-11-26T14:36:15.093169Z",
        "last_login": "2020-11-26T14:45:13.455166Z",
        "user_type": 1,
        "bazaar_point": 0
}
\end{verbatim}
\subsection{/api/user/profile/}\label{apiuserprofile}
detailed description of the specified user(token):

\begin{verbatim}
> GET {{url}}/api/user/profile/
> HEADER {
"Authorization": "Token f0653a57e1e4686f9e56425f5660b00baa942657"
}

-> {
        "id": 61,
        "email": "rajah.faolan@extraale.com",
        "first_name": "",
        "last_name": "",
        "date_joined": "2020-11-26T14:36:15.093169Z",
        "last_login": "2020-11-26T14:45:13.455166Z",
        "user_type": 1,
        "bazaar_point": 0
}
\end{verbatim}
\subsection{/api/user/login/}\label{apiuserlogin}
login request that returns the user and the token

requires `username'',`password'' to authenticate

returns 400 if failed

returns 200 and `token'',`user\_id'' as JSON:

\begin{verbatim}
> POST {{url}}/api/user/login/
> BODY {
    "username": "rajah.faolan@extraale.com",
    "password": "password"
}

-> {
    "token": "f0653a57e1e4686f9e56425f5660b00baa942657",
    "user_id": 61,
    "email": "rajah.faolan@extraale.com",
    "password": "password"
}
\end{verbatim}
\subsection{/api/user/signup/}\label{apiusersignup}
signup request which sends an email to activate the user later

requires `username'',`password'', \`\`user\_type''

returns 400 if requirements not satisfied

returns 201 if succesful, sends mail to the given email:

\begin{verbatim}
> POST {{url}}/api/user/signup/
> BODY {
    "username": "rajah.faolan@extraale.com,
    "password": "password",
    "user_type": "1"
}

-> {
    "message": "An mail has been sent to your email, please check it"
}
\end{verbatim}
\subsection{/api/user/activate/$<uidb64>$/}\label{apiuseractivate}
account activation link for the specified user

returns 200 if verification complete

returns 400 if there has been a problem with a json body explaining the
problem, ie: \texttt{\{"message": "user is already verified"\}}:

\begin{verbatim}
> GET /api/user/activate/MjU/

-> {
    "message": "Your Account, rajah.faolan@extraale.com has been activated"
}
\end{verbatim}

