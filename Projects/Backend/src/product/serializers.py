from pygments.lexers import get_all_lexers
from pygments.styles import get_all_styles
from rest_framework import serializers

from .models import Product, Label, Category, ProductList, Comment, SubOrder, SearchHistory, Payment, Delivery

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
    id = serializers.IntegerField(read_only=True)
    name = serializers.CharField(required=True, allow_blank=False, max_length=255)
    parent = serializers.StringRelatedField(read_only=True)

    class Meta:
        model = Category
        fields = ("name", "parent", "id")

    def get_fields(self):
        fields = super(CategorySerializer, self).get_fields()
        fields['parent'] = serializers.StringRelatedField()
        return fields

    def to_representation(self, instance):
        # We need to swap null parent with empty string ""
        data = super().to_representation(instance)
        if not data['parent']:
            data['parent'] = ""
        return data


class ProductSerializer(serializers.Serializer):
    id = serializers.IntegerField(read_only=True)
    name = serializers.CharField(required=True, allow_blank=False, max_length=255)
    brand = serializers.CharField(required=True, allow_blank=False, max_length=255)
    labels = serializers.StringRelatedField(read_only=True, many=True)
    detail = serializers.CharField(max_length=1023, required=False)
    category = CategorySerializer(read_only=True)
    price = serializers.FloatField()
    stock = serializers.IntegerField()
    sell_counter = serializers.IntegerField(read_only=True)
    rating = serializers.FloatField(read_only=True)
    vendor = serializers.PrimaryKeyRelatedField(read_only=True, default=serializers.CurrentUserDefault())
    picture = serializers.ImageField(required=False)

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
        fields = ("id", "name", "brand", "price", "stock", "sell_counter", "rating", "vendor", "picture", "detail")


class ProductListSerializer(serializers.ModelSerializer):
    # for some reason, this causes POST requests to not work, commenting out for now
    # customer = serializers.StringRelatedField(read_only=True)
    products = ProductSerializer(many=True, source="product_set", required=False)

    class Meta:
        model = ProductList
        fields = ("id", "name", "customer", "products", "is_private")


class SearchHistorySerializer(serializers.ModelSerializer):
    user = serializers.IntegerField(read_only=True)
    searched = serializers.CharField(required=True, allow_blank=False, max_length=255)

    class Meta:
        model = SearchHistory
        fields = ("user", "searched")

    def create(self, validated_data):
        return SearchHistory.objects.create(**validated_data)


class CommentSerializer(serializers.ModelSerializer):
    customer_name = serializers.RelatedField(source='user', read_only=True)

    class Meta:
        model = Comment
        fields = '__all__'


class SubOrderSerializer(serializers.ModelSerializer):
    class Meta:
        model = SubOrder
        fields = '__all__'
        extra_kwargs = {'purchased': {'write_only': True}}


class PaymentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payment
        fields = '__all__'
    def create(self, validated_data):
        return Payment.objects.create(**validated_data)
    def update(self, instance, validated_data):
        for (key, value) in validated_data.items():
            setattr(instance, key, value)
        instance.save()
        return instance


class DeliverySerializer(serializers.ModelSerializer):
    class Meta:
        model = Delivery
        fields = '__all__'
    def create(self, validated_data):
        return Delivery.objects.create(**validated_data)