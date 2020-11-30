from rest_framework import serializers

from .models import Location


class LocationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Location
        fields = ("id", "address_name", "address", "postal_code", "user")
        extra_kwargs = {'user': {'write_only': True}}
