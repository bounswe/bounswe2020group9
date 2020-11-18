from rest_framework import serializers
from .models import Product
from pygments.lexers import get_all_lexers
from pygments.styles import get_all_styles

LEXERS = [item for item in get_all_lexers() if item[1]]
LANGUAGE_CHOICES = sorted([(item[1][0], item[0]) for item in LEXERS])
STYLE_CHOICES = sorted([(item, item) for item in get_all_styles()])


class ProductSerializer(serializers.Serializer):
    id = serializers.IntegerField(read_only=True)
    name = serializers.CharField(required=True, allow_blank=False, max_length=255)
    brand = serializers.CharField(required=True, allow_blank=False, max_length=255)
    price = serializers.FloatField()
    #vendor = serializers.RelatedField(source="vendor", read_only=True)

    def create(self, validated_data):
        return Product.objects.create(**validated_data)

    def update(self, instance, validated_data):
        instance.name = validated_data.get("name", instance.name)
        instance.brand = validated_data.get("brand", instance.name)
        instance.price = validated_data.get("price", instance.name)
        instance.save()
        return instance

    class Meta:
        model = Product
        fields = ("id", "name", "brand", "price")