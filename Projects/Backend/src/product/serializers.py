from pygments.lexers import get_all_lexers
from pygments.styles import get_all_styles
from rest_framework import serializers
from rest_framework.fields import CurrentUserDefault

from .models import Product, Label, Category, ProductList

LEXERS = [item for item in get_all_lexers() if item[1]]
LANGUAGE_CHOICES = sorted([(item[1][0], item[0]) for item in LEXERS])
STYLE_CHOICES = sorted([(item, item) for item in get_all_styles()])




class LabelSerializer(serializers.ModelSerializer):
    # id = serializers.IntegerField(read_only=True)
    name = serializers.CharField(required=True, allow_blank=False, max_length=255)

    class Meta:
        model = Label
        fields = ("name",)


class CategorySerializer(serializers.ModelSerializer):
    # id = serializers.IntegerField(read_only=True)
    name = serializers.CharField(required=True, allow_blank=False, max_length=255)
    parent = serializers.StringRelatedField(read_only=True)

    class Meta:
        model = Category
        fields = ("name", "parent")


class ProductSerializer(serializers.Serializer):
    id = serializers.IntegerField(read_only=True)
    name = serializers.CharField(required=True, allow_blank=False, max_length=255)
    brand = serializers.CharField(required=True, allow_blank=False, max_length=255)
    labels = serializers.StringRelatedField(read_only=True, many=True)
    categories = serializers.StringRelatedField(read_only=True, many=True)
    price = serializers.FloatField()
    stock = serializers.IntegerField()
    sell_counter = serializers.IntegerField()
    rating = serializers.FloatField(read_only=True)
    vendor = serializers.PrimaryKeyRelatedField(read_only=True, default=serializers.CurrentUserDefault())
    picture = serializers.ImageField(required=False)

    class Meta:
        model = Product

    def create(self, validated_data):
        return Product.objects.create(**validated_data)

    def update(self, instance, validated_data):
        instance.name = validated_data.get("name", instance.name)
        instance.brand = validated_data.get("brand", instance.brand)
        instance.price = validated_data.get("price", instance.price)
        instance.stock = validated_data.get("stock", instance.stock)
        instance.sell_counter = validated_data.get("sell_counter", instance.sell_counter)
        instance.rating = validated_data.get("rating", instance.rating)
        instance.picture = validated_data.get("picture", instance.picture)
        instance.save()
        return instance

    class Meta:
        model = Product
        fields = ("id", "name", "brand", "price", "stock", "sell_counter", "rating", "vendor", "picture")


class ProductListSerializer(serializers.ModelSerializer):
    # for some reason, this causes POST requests to not work, commenting out for now
    # customer = serializers.StringRelatedField(read_only=True)
    products = ProductSerializer(many=True, source="product_set")
    class Meta:
        model = ProductList
        fields = ("id", "name", "customer", "products")