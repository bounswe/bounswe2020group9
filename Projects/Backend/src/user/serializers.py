from rest_framework import serializers

from .models import User


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = (
        'id', 'username', 'password', 'email', 'first_name', 'last_name', 'date_joined', 'last_login', 'user_type',
        'bazaar_point', 'company')
        extra_kwargs = {'password': {'write_only': True}, 'username': {'write_only': True}}

    def create(self, validated_data):

        user = User(
            email=validated_data['username'],
            username=validated_data['username'],
            user_type=validated_data['user_type']
        )
        if "first_name" in validated_data:
            user.first_name = validated_data['first_name']
        if 'last_name' in validated_data:
            user.last_name = validated_data['last_name']
        user.set_password(validated_data['password'])
        if validated_data['user_type'] == 2:
            if "company" in validated_data:
                user.company = validated_data['company']
        user.save()
        return user

    def update(self, instance, validated_data):
        password = validated_data.pop('password', None)

        for (key, value) in validated_data.items():
            setattr(instance, key, value)

        if password is not None:
            instance.set_password(password)

        instance.save()

        return instance
