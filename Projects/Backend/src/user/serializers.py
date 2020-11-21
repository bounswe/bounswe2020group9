from rest_framework import serializers
from .models import  User



class UserSerializer(serializers.ModelSerializer):

    class Meta:
        model = User
        fields = '__all__'
        extra_kwargs = {'password': {'write_only': True}}


    def create(self, validated_data):
        user = User(
            email=validated_data['username'],
            username=validated_data['username']
        )
        user.set_password(validated_data['password'])
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
