from user.models import User, Vendor, Customer, Admin


def create_user(user_type, email, password, name="", surname=""):
    new_user = User()
    new_user.set_password(password)
    user_types = {v: k for k, v in dict(new_user.USER_TYPES).items()}
    # user type is a string, get the related integer, for more look at User.USER_TYPES
    new_user.user_type = user_types[user_type]
    new_user.email = email
    new_user.username = email
    # TODO new_user.username_validator
    new_user.first_name = name
    new_user.last_name = surname
    try:
        new_user.save()
    except:
        print("ERROR")
        return
    if user_type == "Vendor":
        new_type = Vendor()
    elif user_type == "Customer":
        new_type = Customer()
    elif user_type == "Admin":
        new_type = Admin()
    else:
        print("ERROR")
        return
    new_type.user_id = new_user.id
    try:
        new_type.save()
    except:
        print("ERROR")
        return
    return new_user


def delete_user(email):
    deleing_user = User.objects.get(email=email)
    User.delete(deleing_user)
